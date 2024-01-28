extends Node3D

@onready var player = $Player

var background_x = 0.0

var MAX_ENEMIES = 5
var ENEMY_SPAWN_INTERVAL = 3
var Mob = preload("res://scenes/StandinMob.tscn")

func spawn_enemies():
	while Globals.n_alive_enemies < MAX_ENEMIES:
		var m: RigidBody3D = Mob.instantiate()
		m.position = $SpawnPoint.position
		m.set_player(player)
		add_child(m)
		await get_tree().create_timer(ENEMY_SPAWN_INTERVAL).timeout
	


func _ready():
	# Mouse invisible and stuck to center of screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	get_tree().call_group("zombies", "set_player", player)
	get_tree().call_group("spawners", "set_player", player)
	get_tree().call_group("spawners", "set_world", self)
	$HUDLayer/HUD/Timer.text = str(floor($GameTimer.time_left))

func _process(delta):
	spawn_enemies()
	$HUDLayer/HUD/Timer.text = str(floor($GameTimer.time_left))
	if $GameTimer.time_left <= 10.0:
		$HUDLayer/HUD/Timer.set_modulate(Color(1.0, 0.0, 0.0))
	background_x += delta
	$WorldEnvironment.environment.set_bg_color(Color(
		0.25*cos(background_x/10)+0.75,
		0.25*cos((background_x+5)/10)+0.75,
		0.25*cos((background_x+10)/10)+0.75
#		sin((background_x/10)+1),
#		sin(((background_x+4.0)/10)+1),
#		sin(((background_x+8.0)/10)+1)
	))

func _on_game_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/UI/GameOver.tscn")



