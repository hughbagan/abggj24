class_name Pickup extends Area3D

@onready var MobScene = preload("res://scenes/Actor.tscn")
@onready var spawn_point = get_node("/root/World/SpawnPoint").global_position
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

func _on_body_entered(body):
	if body is Player:
		# Give the player a new weapon
		body.weapon.hide()
		while true:
			var new_weapon = body.weapons[randi() % body.weapons.size()]
			if body.weapon == new_weapon:
				continue
			else:
				body.weapon = new_weapon
				break
		body.weapon.show()
		var new_mob = MobScene.instantiate()
		get_parent().add_child(new_mob)
		new_mob.global_position = spawn_point
		queue_free()
