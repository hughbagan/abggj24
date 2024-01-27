extends Button

@onready var button : Button = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	button.connect("pressed", _on_pressed)


func _on_pressed():
	get_tree().quit()
