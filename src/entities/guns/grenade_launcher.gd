extends Node3D

@export var ammo: int = 10
@export var throw_force: float = -20.0
@export var up_direction: float = 2
@export var cool_down_count: float = 0.3
#@export var damage: float = 5.0

signal _fire
signal _drop
signal _empty
signal _destroyed

@onready var timer: Timer = $Timer
@onready var weapon: Node3D = $Weapon
@onready var barrel: RayCast3D = weapon.barrel
var grenade = load("res://src/entities/throwable/grenade.tscn")
var grenade_instance

var cool_down: bool = false
var current_ammo: int = 0
var available: bool = false

@export var shooter : CharacterBody3D

func _on_weapon_manager_2_fire() -> void:
	if available:
		if !cool_down:
			if current_ammo < ammo:
				current_ammo += 1
				spawn_grenade()
				cool_down = true
				timer.start(cool_down_count)

func spawn_grenade() -> void:
	grenade_instance = grenade.instantiate()
	grenade_instance.shooter = shooter
	grenade_instance.position = barrel.global_position
	grenade_instance.transform.basis = weapon.global_transform.basis
	get_parent().get_parent().get_parent().add_child(grenade_instance)
	grenade_instance.apply_central_impulse(-weapon.global_transform.basis.z.normalized() * throw_force + Vector3(0, up_direction, 0))

func _on_timer_timeout() -> void:
	cool_down = false
