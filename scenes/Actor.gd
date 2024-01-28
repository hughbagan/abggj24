class_name Actor extends RigidBody3D

const MOVE_SPEED = 5.0
const MOUSE_SENS = 0.3

@onready var raycast = $RayCast3D
@onready var anim_player = $AnimationPlayer
@onready var path_timer = $PathTimer
@onready var hitbox = $Hitbox
@onready var camera = $Camera3D
@onready var nav = $NavigationAgent3D
@onready var sprite = $Sprite3D
@onready var gridmap := get_node("/root/World/NavigationRegion3D/GridMap")
@onready var score_label := get_node("/root/World/HUDLayer/HUD/Score")

enum {PUNCH_NONE, PUNCH_LEFT, PUNCH_RIGHT}
var punch_mode = PUNCH_NONE

var direction = Vector3()
var move_speed = 0.0

var player = null
var navigation = null
var dead = false
var hit = false
var path = []
@export var hp = 5
var PickupScene = preload("res://scenes/Pickup.tscn")
var combo = 0
var on_floor = true

signal died

func _ready():
	player = get_node("/root/World/Player")
	add_to_group("zombies")
	if player:
		connect("died", Callable(player, "_on_Zombie_died"))
	anim_player.play("walk")
	nav.velocity_computed.connect(Callable(_on_velocity_computed))
	get_node("/root/World/FloorArea3D").connect("body_entered", Callable(self, "_on_floor_entered"))
	get_node("/root/World/FloorArea3D").connect("body_exited", Callable(self, "_on_floor_exited"))

func set_player(p):
	player = p

func set_navigation(n):
	navigation = n

func _physics_process(delta):
	if dead:
		return
	hitbox.global_position = global_position
	camera.global_position = global_position

#	print(angular_velocity)
	if hit:
		sprite.billboard = BaseMaterial3D.BillboardMode.BILLBOARD_DISABLED
		#anim_player.pause()
		sprite.rotation = rotation
		apply_torque(Vector3(1, 1, 1)*5)
		# TODO: Figuring out when we're done flying needs some massaging
#		if (abs(angular_velocity.x) <= 0.03 and abs(angular_velocity.y) <= 0.03) \
#		or (abs(angular_velocity.x) <= 0.03 and abs(angular_velocity.z) <= 0.03) \
#		or (abs(angular_velocity.y) <= 0.03 and abs(angular_velocity.z) <= 0.03):
#			hit = false
	else:
		sprite.billboard = BaseMaterial3D.BillboardMode.BILLBOARD_FIXED_Y
		#anim_player.play()
		set_movement_target(player.global_position)
		if nav.is_navigation_finished():
			return
		var next_path_position:Vector3 = nav.get_next_path_position()
		var current_agent_position:Vector3 = global_position
		var new_velocity:Vector3 = (next_path_position - current_agent_position).normalized() * MOVE_SPEED
		if nav.avoidance_enabled:
			nav.set_velocity(new_velocity)
		else:
			_on_velocity_computed(new_velocity)

func set_movement_target(movement_target:Vector3):
	nav.set_target_position(movement_target)

func _on_velocity_computed(safe_velocity:Vector3):
	linear_velocity = safe_velocity


#func kill():
#	dead = true
#	$CollisionShape3D.disabled = true
#	anim_player.play("die")
#	Globals.score += 100
#	emit_signal("died")


func _on_body_entered(body):
	if body is GridMap and not on_floor:
		combo += 1
		if combo > Globals.score:
			Globals.score = combo
			score_label.text = str(Globals.score)


func _on_floor_entered(body):
	if not on_floor:
		queue_free()
	on_floor = true
	if combo > Globals.levels[Globals.level]:
		# Level up!
		# Increase the level
		for l in range(Globals.levels.size()):
			if Globals.levels[l] > combo:
				break
			Globals.level = l
		# Increase the game timer
		var game_timer = get_node("/root/World/GameTimer")
		game_timer.start(game_timer.wait_time + 30.0)
		# Spawn a pickup
		var pickup = PickupScene.instantiate()
		get_parent().add_child(pickup)
		pickup.global_position = global_position

		print("level ", Globals.level, ": ", Globals.levels[Globals.level])
	combo = 0

func _on_floor_exited(body):
	on_floor = false
