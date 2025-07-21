extends Node3D

@export var SPEED: int = 20

@onready var mesh = $projectile
@onready var ray = $colision
@onready var particle = $sparks

func _ready():
	pass

func _process(delta: float) -> void:
	#print_debug(ray.position)
	if ray.is_colliding():
		print_debug("hit")
		mesh.visible = false
		particle.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()
	else:
		position += transform.basis * Vector3(0, -SPEED, 0) * delta


func _on_timer_timeout() -> void:
	queue_free() 
