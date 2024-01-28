extends Node3D

func _ready():
	pass

func make_walking():
	var anim = $AnimationPlayer.get_animation("MobRun")
	anim.loop_mode = Animation.LOOP_LINEAR
	$AnimationPlayer.play("MobRun")

func make_ragdoll():
	$AdvArmature/Skeleton3D.physical_bones_start_simulation([
		"Head",
		"Hip-Left",
		"Hip-Right",
		"Shoulder-Left",
		"Shoulder-Right",
		"Elbow-Left",
		"Elbow-Right",
		"Knee-Left",
		"Knee-Right",
	])

func die():
	for bone in $AdvArmature/Skeleton3D.get_children():
		if not bone.has_method("apply_impulse"):
			continue
		bone.get_child(0).set_deferred("disabled", false)
	$AdvArmature/Skeleton3D.physical_bones_start_simulation(["Root"])
