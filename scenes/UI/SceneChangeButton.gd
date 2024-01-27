extends Button

@export var next_scene : String
@onready var button : Button = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	button.connect("pressed", _on_pressed)


func _on_pressed():
	get_tree().change_scene_to_file(next_scene)
