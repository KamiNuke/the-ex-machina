extends RigidBody3D

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var timer: Timer = $Timer

@export var fuse_time: float = 3.5

var explosion = load("res://src/entities/explosion.tscn")
var explosion_instance

@export var damage = 20
var shooter = null

func _ready() -> void:
	timer.start(fuse_time)

func _on_timer_timeout() -> void:
	explosion_instance = explosion.instantiate()
	explosion_instance.set_damage(damage)
	explosion_instance.set_shooter(shooter)
	explosion_instance.position = mesh.global_position
	explosion_instance.transform.basis = mesh.global_transform.basis
	
	mesh.visible = false
	get_parent().add_child(explosion_instance)
	await get_tree().create_timer(1.0).timeout
	queue_free()
