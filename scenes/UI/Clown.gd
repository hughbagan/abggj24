extends Sprite2D

var initalY
var timeElapsed
@export var amplitude: float = 30.0
@export var deltaOffset: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	initalY = position.y;
	timeElapsed = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeElapsed += ( delta * deltaOffset )
	position.y = initalY + ( sin(timeElapsed) * amplitude )
