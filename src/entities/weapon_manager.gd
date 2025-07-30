extends Node3D

@export var cooldown_count: float = 0.5

@onready var timer: Timer = $Timer
@onready var guns = get_children(false)
var switch_cooldown: bool = false

signal fire

@onready var grenade_launcher: Node3D = $GrenadeLauncher
@onready var hitscan_weapon: Node3D = $HitscanWeapon
@onready var projectile_weapon: Node3D = $ProjectileWeapon

func _ready() -> void:
	for g in guns:
		if g.get_index() > 0:
			g.weapon.model.visible = false
			g.available = false

func switch_weapon(number: int) -> void:
	if !switch_cooldown:
		print_debug(number)
		for g in guns:
			if g.get_index() > 0:
				g.weapon.model.visible = false
				g.available = false
		guns[number].weapon.model.visible = true
		guns[number].available = true
		timer.start(cooldown_count)


func _on_timer_timeout() -> void:
	switch_cooldown = false

func _on_player_controller__attack() -> void:
	emit_signal("fire")

func add_ammo_to_each_weapon(grenades, lasers, bullets):
	if is_instance_valid(grenade_launcher):
		grenade_launcher.ammo += grenades
	if is_instance_valid(hitscan_weapon):
		hitscan_weapon.ammo += lasers
	if is_instance_valid(projectile_weapon):
		projectile_weapon.ammo += bullets

func get_grenade_launcher_ammo():
	return if_weapon_ammo_exist(grenade_launcher)
	
func get_hitscan_ammo():
	return if_weapon_ammo_exist(hitscan_weapon)
	
func get_projectile_ammo():
	return if_weapon_ammo_exist(projectile_weapon)

func if_weapon_ammo_exist(object):
	if is_instance_valid(object):
		return object.ammo - object.current_ammo
	else:
		return null
