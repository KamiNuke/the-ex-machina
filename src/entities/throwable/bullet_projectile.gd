extends Node3D

@export var SPEED: int = 60
@export var GRAVITY: float = 2

var cur_gravity: float = 0

@onready var mesh = $projectile
@onready var ray = $colision
@onready var particle = $sparks

var velocity: Vector3 = Vector3.ZERO

@export var damage = 5
var shooter = null

func _ready():
	pass

func _process(delta: float) -> void:
	#print_debug(ray.position)
	if ray.is_colliding():
		var collider_instance = ray.get_collider()
		if is_instance_valid(collider_instance) and is_instance_valid(shooter):
			if collider_instance != shooter and collider_instance.has_method("hit"):
				var enemy_conflict = collider_instance.is_in_group("enemy") != shooter.is_in_group("enemy")
				var player_conflict = collider_instance.is_in_group("player") != shooter.is_in_group("player")
				if enemy_conflict or player_conflict:
					collider_instance.call_deferred("hit", damage)

			ray.enabled = false
		#print_debug("hit")
		mesh.visible = false
		particle.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()
	else:
		cur_gravity += delta * GRAVITY
		position += transform.basis * Vector3(cur_gravity, -SPEED, 0) * delta * SPEED


func _on_timer_timeout() -> void:
	queue_free() 

func set_shooter(current_shooter):
	shooter = current_shooter
