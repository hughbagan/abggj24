extends Node3D

@onready var player = $Player
var background_x = 0.0

func _ready():
	# Mouse invisible and stuck to center of screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	get_tree().call_group("zombies", "set_player", player)
	get_tree().call_group("spawners", "set_player", player)
	get_tree().call_group("spawners", "set_world", self)
	$HUDLayer/HUD/Timer.text = str(floor($GameTimer.time_left))

func _process(delta):
	$HUDLayer/HUD/Timer.text = str(floor($GameTimer.time_left))
	if $GameTimer.time_left <= 10.0:
		$HUDLayer/HUD/Timer.set_modulate(Color(1.0, 0.0, 0.0))
	background_x += delta
	$WorldEnvironment.environment.set_bg_color(Color(
		0.25*cos(background_x/10)+0.5,
		0.25*cos((background_x+5)/10)+0.5,
		0.25*cos((background_x+10)/10)+0.5
#		sin((background_x/10)+1),
#		sin(((background_x+4.0)/10)+1),
#		sin(((background_x+8.0)/10)+1)
	))

func _on_game_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/UI/GameOver.tscn")
