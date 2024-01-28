extends Button

@onready var button : Button = $"."
@export var next_scene : String
@export var should_quit : bool = false
@export var hover : float = 1.1

# Called when the node enters the scene tree for the first time.
func _ready():
	button.connect("pressed", _on_pressed)
	button.connect("mouse_entered", _on_mouse_enter)
	button.connect("mouse_exited", _on_mouse_leave)


func _on_mouse_enter():
	var childNode = get_child(0)
	if(childNode != null):
		childNode.scale *= hover
	
func _on_mouse_leave():
	var childNode = get_child(0)
	if(childNode != null):
		childNode.scale /= hover

func _on_pressed():
	if(should_quit):
		get_tree().quit()
	else:
		get_tree().paused = false
		get_tree().change_scene_to_file(next_scene)
	
