extends Sprite2D

var initalRot
var timeElapsed
@export var amplitude: float = 1
@export var deltaOffset: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	timeElapsed = 0
	initalRot = rotation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeElapsed += ( delta * deltaOffset )
	rotation = initalRot + ( sin(timeElapsed) * amplitude )
