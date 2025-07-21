extends Node3D

@export var SPEED: int = 20

@onready var mesh = $projectile
@onready var ray = $colision
@onready var particle = $sparks

func _ready():
	pass

func _process(delta: float) -> void:
	#
	var collider_instance = ray.get_collider()
	if collider_instance != null:
		if collider_instance.is_in_group("enemy") or collider_instance.is_in_group("player"):
			collider_instance.hit(5)
	
	#print_debug(ray.position)
	if ray.is_colliding():
		mesh.visible = false
		particle.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()
	else:
		position += transform.basis * Vector3(-SPEED, 0, 0) * delta


func _on_timer_timeout() -> void:
	queue_free() 
