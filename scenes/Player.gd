class_name Player extends CharacterBody3D

const MOVE_SPEED = 7
const MOUSE_SENS = 0.3

@export var hit_sfx: EventAsset
@onready var anim_player = $AnimationPlayer
@onready var raycast = $RayCast3D
@onready var reload_timer = $ReloadTimer
@onready var ammo_label = $CanvasLayer/AmmoLabel
@onready var ammo_label_timer = $AmmoLabelTimer
@onready var camera = $Camera3D
@onready var punch_range = $PunchRange
@onready var studio_trigger = $StudioGlobalParameterTrigger
@onready var weapons = [
	$CanvasLayer/Weapons/Pan,
	$CanvasLayer/Weapons/Banana,
	$CanvasLayer/Weapons/Hammer,
	$CanvasLayer/Weapons/Bat,
	$CanvasLayer/Weapons/Baseball,
	$CanvasLayer/Weapons/Bass,
	$CanvasLayer/Weapons/Fart,
	$CanvasLayer/Weapons/Sword,
	$CanvasLayer/Weapons/Bomb
]
var weapon
var weapon_tween

enum {PUNCH_NONE, PUNCH_LEFT, PUNCH_RIGHT}
var punch_mode = PUNCH_NONE

var ammo = 6
var reload = 0

var last_position = null

var BEACON_THRESHOLD = 1

func _ready():
	#aawait get_tree().idle_frame # wait one frame
#	get_tree().call_group("zombies", "set_player", self)
	randomize()
	new_random_weapon()

func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotation_degrees.y -= MOUSE_SENS * event.relative.x
			rotation_degrees.x = clamp(rotation_degrees.x - event.relative.y * MOUSE_SENS, -90, 90)

func _physics_process(delta):
	var move_vec = Vector3()
	if Input.is_action_pressed("move_forwards"):
		move_vec.z -= 1
	if Input.is_action_pressed("move_backwards"):
		move_vec.z += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	velocity = move_vec.normalized().rotated(Vector3(0,1,0), rotation.y) * MOVE_SPEED

	if move_vec != Vector3():
		move_and_slide()

	var left = Input.is_action_just_pressed("punch_left")
	var right = Input.is_action_just_pressed("punch_right")

	if (left or right) and reload_timer.is_stopped():
		weapon.show()
		reload = 0
		var col = raycast.get_collider()
		if not is_instance_valid(col):
			return
		if raycast.is_colliding() and (col is Actor or col.has_method("kill")):
			if col.hitbox:
				if punch_range.overlaps_area(col.hitbox):
					var pos_raised = Vector3(
						raycast.target_position.x,
						raycast.target_position.y+2000,
						raycast.target_position.z
					)
					var to = raycast.to_global(pos_raised)
					var dir = global_transform.origin.direction_to(to)
					if col.has_method("ragdoll_impulse"):
						col.ragdoll_impulse(dir.normalized()*20)
					else:
						col.apply_impulse(dir.normalized()*20)
					#print("PUSH", raycast.target_position, pos_raised, to, dir, dir.normalized()*10)
					col.hit = true

					FMODRuntime.play_one_shot(hit_sfx)
		#rotation_degrees.x += 4.0 # gun recoil
		if weapon_tween:
			weapon_tween.kill()
		weapon_tween = get_tree().create_tween()
		weapon_tween.tween_property(weapon, "rotation_degrees", weapon.rotation_degrees-360, 0.25)
		reload_timer.start()

func kill():
	PauseManager.pause()

func _on_ReloadTimer_timeout():
	pass

func _on_AmmoLabelTimer_timeout():
	ammo_label.hide()

#func _on_Zombie_died():
#	if (Globals.score % 1000) == 0:
#		show_score()
#		ammo_label_timer.start(1.0)

func new_random_weapon():
	for node in $CanvasLayer/Weapons.get_children():
		node.hide()
	var new_index
	while true:
		new_index = randi() % weapons.size()
		if weapons[new_index] == weapon:
			continue
		else:
			break
	weapon = weapons[new_index]
	weapon.show()
	studio_trigger.value = new_index
	studio_trigger.trigger()
