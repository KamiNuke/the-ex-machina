extends Node3D

@export var ammo: int = 10
@export var cool_down_count: float = 0.3
#if c\d = 0 - laser modв
#@export var damage: float = 5.0

signal _fire
signal _drop
signal _empty
signal _destroyed

@onready var timer: Timer = $Timer
@onready var weapon: Node3D = $Weapon
@onready var barrel: RayCast3D = weapon.barrel
@onready var aim_ray: RayCast3D = $AimRay
@onready var aim_ray_end: Node3D = $AimEnd

var trail = load("res://src/entities/throwable/hitscan.tscn")
var trail_instance

var cool_down: bool = false
var current_ammo: int = 0
var available: bool = false

@export var damage = 5
@export var shooter : CharacterBody3D

func _on_weapon_manager_2_fire() -> void:
	if available:
		if !cool_down:
			if current_ammo < ammo:
				current_ammo += 1
				trail_instance = trail.instantiate()
				var pos
				if aim_ray.get_collision_point():
					pos = aim_ray.get_collision_point()
					
					#damage using laser
					if aim_ray.is_colliding():
						var collider_instance = aim_ray.get_collider()
						if is_instance_valid(collider_instance) and is_instance_valid(shooter):
							if collider_instance != shooter and collider_instance.has_method("hit"):
								var enemy_conflict = collider_instance.is_in_group("enemy") != shooter.is_in_group("enemy")
								var player_conflict = collider_instance.is_in_group("player") != shooter.is_in_group("player")
								if enemy_conflict or player_conflict:
									collider_instance.call_deferred("hit", damage)
				else:
					pos = aim_ray_end.position
				trail_instance.init(barrel.global_position, pos)
				cool_down = true
				timer.start(cool_down_count)
				get_parent().get_parent().get_parent().add_child(trail_instance)

func _on_timer_timeout() -> void:
	cool_down = false


func _on_weapon_manager_2_empty() -> void:
	pass # Replace with function body.
