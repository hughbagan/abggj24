extends Label

var last_score = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(last_score != Globals.score):
		last_score = Globals.score
		text = str(Globals.score)
		
