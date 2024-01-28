extends Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS # exclude from pause

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			pause()
		elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			get_tree().quit()

	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		get_tree().paused = false

func resume():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	var menu = get_node("/root/World/PauseLayer/PauseMenu")
	if(menu != null):
		menu.hide()

func pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# PAUSE functionality goes here...
	get_tree().paused = true
	var menu = get_node("/root/World/PauseLayer/PauseMenu")
	if(menu != null):
		menu.show()
