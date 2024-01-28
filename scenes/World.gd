extends Node3D

@onready var player = $Player

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


func _on_game_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/UI/GameOver.tscn")
