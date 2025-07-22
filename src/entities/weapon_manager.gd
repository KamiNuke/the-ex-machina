extends Node3D

@onready var guns = get_children(false)
var switch_cooldown: bool = false

func _ready() -> void:
	for g in guns:
		if g.get_index() > 0:
			g.weapon.model.visible = false
			g.available = false
		print_debug(g.get_index(false))

func switch_weapon(number: int) -> void:
	if !switch_cooldown:
		print_debug(number)
		for g in guns:
			if g.get_index() > 0:
				g.weapon.model.visible = false
				g.available = false
		print_debug(guns[number].weapon.model.visible)
		guns[number].weapon.model.visible = true
		guns[number].available = true
		print_debug(guns[number].weapon.model.visible)


func _on_timer_timeout() -> void:
	switch_cooldown = false
