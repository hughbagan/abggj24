extends TextureProgressBar

@onready var ticker : TextureProgressBar = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var timer = get_node("/root/World/GameTimer");
	var time_left = timer.time_left
	var max_time = timer.wait_time
	ticker.value = round((time_left / max_time) * 100)
