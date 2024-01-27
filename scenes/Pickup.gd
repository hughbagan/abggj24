class_name Pickup extends Area3D

@onready var sprite = $Sprite3D
@onready var sprite_pos = sprite.global_position
var sprite_float_x = 0.0

func _ready():
	pass

func _process(delta):
	sprite_float_x += delta
	sprite.rotation = Vector3(
		sprite.rotation.x,
		sprite.rotation.y+delta*2,
		sprite.rotation.z
	)
	sprite.global_position = Vector3(
		sprite.global_position.x,
		sprite_pos.y+sin(sprite_float_x)/8,
		sprite.global_position.z
	)
