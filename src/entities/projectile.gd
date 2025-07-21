extends Node3D

@export var SPEED: int = 60

@onready var mesh = $projectile
@onready var ray = $colision
@onready var particle = $sparks

var current_damage = 0
var current_shooter = null

func _ready():
	pass

func _process(delta: float) -> void:
	#print_debug(ray.position)
	if ray.is_colliding():
		var collider_instance = ray.get_collider()
		if collider_instance != null:
			var parent = get_parent()
			if parent != null:
				if collider_instance != current_shooter and collider_instance.has_method("hit"):
					collider_instance.hit(current_damage)
			ray.enabled = false
		mesh.visible = false
		particle.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()
	else:
		position += transform.basis * Vector3(-SPEED, 0, 0) * delta


func _on_timer_timeout() -> void:
	queue_free() 

func set_damage(damage):
	current_damage = damage

func set_shooter(shooter):
	current_shooter = shooter
