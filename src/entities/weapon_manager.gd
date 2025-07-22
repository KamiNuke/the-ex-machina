extends Node3D

func switch_weapon(number: int) -> void:
	var guns = get_children(false)
	for g in guns:
		g.visible = false
		g.available = false
	
	guns[number].visible = true
	guns[number].available = true
