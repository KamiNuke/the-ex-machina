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
	grenade_launcher.ammo += grenades
	hitscan_weapon.ammo += lasers
	projectile_weapon.ammo += bullets
