extends Button

@onready var button : Button = $"."
@export var enter_fx: EventAsset
@export var click_fx: EventAsset
@export var hover : float = 1.1

# Called when the node enters the scene tree for the first time.

# Called when the node enters the scene tree for the first time.
func _ready():
	button.connect("pressed", _on_pressed)
	button.connect("mouse_entered", _on_mouse_enter)
	button.connect("mouse_exited", _on_mouse_leave)


func _on_mouse_enter():
	var childNode = get_child(0)
	if(childNode != null):
		childNode.scale *= hover
		
	if(enter_fx != null):
		FMODRuntime.play_one_shot(enter_fx)
	
func _on_mouse_leave():
	var childNode = get_child(0)
	if(childNode != null):
		childNode.scale /= hover

func _on_pressed():
	
	if(click_fx != null):
		FMODRuntime.play_one_shot(click_fx)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	get_node("/root/World/PauseLayer/PauseMenu").hide()
	
