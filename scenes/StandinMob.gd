extends RigidBody3D

const MOVE_SPEED = 5.0
const MOUSE_SENS = 0.3
const BASE_TIMER_BONUS = 15

#@onready var raycast = $RayCast3D
#@onready var anim_player = $AnimationPlayer
#@onready var path_timer = $PathTimer
@onready var hitbox = $Hitbox
#@onready var camera = $Camera3D
@onready var nav = $NavigationAgent3D
#@onready var sprite = $StandinMob
@onready var gridmap := get_node("/root/World/NavigationRegion3D/GridMap")
@onready var score_label := get_node("/root/World/HUDLayer/HUD/Score")
var PickupScene = preload("res://scenes/Pickup.tscn")

enum {PUNCH_NONE, PUNCH_LEFT, PUNCH_RIGHT}
var punch_mode = PUNCH_NONE

var direction = Vector3()
var move_speed = 0.0

var player = null
var navigation = null
var dead = false
var hit = false
var path = []

var combo = 0
var on_floor = true

signal died

func _ready():
	add_to_group("zombies")
	if player:
		connect("died", Callable(player, "_on_Zombie_died"))
	#anim_player.play("walk")
	nav.velocity_computed.connect(Callable(_on_velocity_computed))
	get_node("/root/World/FloorArea3D").connect("body_entered", Callable(self, "_on_floor_entered"))
	get_node("/root/World/FloorArea3D").connect("body_exited", Callable(self, "_on_floor_exited"))
	
	
	Globals.n_alive_enemies += 1

func set_player(p):
	player = p

func set_navigation(n):
	navigation = n

func look_follow(state: PhysicsDirectBodyState3D, current_transform: Transform3D, target_position: Vector3) -> void:
	var forward_local_axis: Vector3 = Vector3(1, 0, 0)
	var forward_dir: Vector3 = (current_transform.basis * forward_local_axis).normalized()
	var target_dir: Vector3 = (target_position - current_transform.origin).normalized()
	var local_speed: float = clampf(MOVE_SPEED, 0, acos(forward_dir.dot(target_dir)))
	if forward_dir.dot(target_dir) > 1e-4:
		state.angular_velocity = local_speed * forward_dir.cross(target_dir) / state.step

func _integrate_forces(state):
	var target_position = $".".global_transform.origin
	look_follow(state, global_transform, player.global_position)

func _physics_process(delta):
	if dead:
		return
	hitbox.global_position = global_position
	#camera.global_position = global_position

#	print(angular_velocity)
	if hit:
		pass
		#sprite.billboard = BaseMaterial3D.BillboardMode.BILLBOARD_DISABLED
		#anim_player.pause()
		#sprite.rotation = rotation
		# TODO: Figuring out when we're done flying needs some massaging
#		if (abs(angular_velocity.x) <= 0.03 and abs(angular_velocity.y) <= 0.03) \
#		or (abs(angular_velocity.x) <= 0.03 and abs(angular_velocity.z) <= 0.03) \
#		or (abs(angular_velocity.y) <= 0.03 and abs(angular_velocity.z) <= 0.03):
#			hit = false
	else:
		#sprite.billboard = BaseMaterial3D.BillboardMode.BILLBOARD_FIXED_Y
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

func ragdoll_impulse(data):
	$CollisionShape3D/ClownMob.make_ragdoll()
	$".".apply_impulse(data)

func make_walking():
	$CollisionShape3D/ClownMob.make_walking()


func kill():
	dead = true
	$CollisionShape3D.disabled = true
	#anim_player.play("die")
	Globals.score += 100
	emit_signal("died")

func _on_body_entered(body):
	if body is GridMap and not on_floor and hit:
		combo += 1
		if combo > Globals.score:
			Globals.score = combo
			score_label.text = str(Globals.score)

func _on_floor_entered(body):
	if not body == self:
		return
	if not on_floor:
		Globals.n_alive_enemies -= 1
		queue_free()
	on_floor = true
	if combo > Globals.levels[Globals.level]:
		# Level up!
		# Increase the level
		var last_level = Globals.level
		var l = 0
		while(l < Globals.levels.size() - 1):
			l += 1
			if Globals.levels[l] > combo:
				break
		Globals.level = l
		if Globals.level == last_level:
			return
		# Increase the game timer
		var game_timer = get_node("/root/World/GameTimer")
		game_timer.start(game_timer.wait_time + BASE_TIMER_BONUS)
		# Spawn a pickup
		var pickup = PickupScene.instantiate()
		get_parent().add_child(pickup)
		pickup.global_position = global_position
	combo = 0

func _on_floor_exited(body):
	on_floor = false

