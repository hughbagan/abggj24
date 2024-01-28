extends Sprite2D

var initialY
var timeElapsed
@export var amplitude: float = 90.0  # This will be the 'height' the clown moves up
@export var deltaOffset: float = 50.0

# Called when the node enters the scene tree for the first time.
func _ready():
	initialY = position.y
	timeElapsed = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeElapsed += (delta * deltaOffset)

	# Calculate the new position
	var newY = initialY - timeElapsed
	
	# If newY is greater than initialY + amplitude, reset to initialY
	if newY < initialY - amplitude:
		newY = initialY
		timeElapsed = 0  # Resetting timeElapsed to start the cycle again

	position.y = newY
