extends Label

var score = 39

func _on_mob_bounce():
	score += 1
	text = "Score: %s" % score

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Score: %s" % score
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
