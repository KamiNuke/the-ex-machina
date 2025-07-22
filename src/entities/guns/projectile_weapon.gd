extends Node3D

@export var ammo: int = 10
@export var cool_down_count: float = 0.3
#@export var damage: float = 5.0

signal _fire
signal _drop
signal _empty
signal _destroyed

@onready var timer: Timer = $Timer
@onready var weapon: Node3D = $Weapon
@onready var barrel: RayCast3D = weapon.barrel
var projectile = load("res://src/entities/throwable/projectile.tscn")
var projectile_instance

var cool_down: bool = false
var current_ammo: int = 0
#var available: bool = false


func _on_player_controller__attack() -> void:
	if !cool_down:
		if current_ammo < ammo:
			current_ammo += 1
			spawn_projectile()
			cool_down = true
			timer.start(cool_down_count)

func spawn_projectile() -> void:
	projectile_instance = projectile.instantiate()
	projectile_instance.position = barrel.global_position
	projectile_instance.transform.basis = barrel.global_transform.basis
	get_parent().get_parent().add_child(projectile_instance)

func _on_timer_timeout() -> void:
	cool_down = false
