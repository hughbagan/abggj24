extends Node3D

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
