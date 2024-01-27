extends Button

@onready var button : Button = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	button.connect("pressed", _on_pressed)


func _on_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	get_node("/root/World/PauseLayer/PauseMenu").hide()
