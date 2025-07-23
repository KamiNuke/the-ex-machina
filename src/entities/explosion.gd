extends Area3D

@onready var coolision_sphere: CollisionShape3D = $CollisionShape3D
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var mesh_core: MeshInstance3D = $MeshInstance3D2
@onready var timer: Timer = $Timer
@onready var particle: GPUParticles3D = $GPUParticles3D

#@export var blast_radius: int = 6
@export var max_damage: int = 10
@export var knockback_amount: int = 25
@export var outer_radius: int = 2
@export var inner_radius: int = 1

var alpha: float = 1.0
const TIME: float = 1.0

func _ready() -> void:
	#coolision_sphere.scale = Vector3(blast_radius, blast_radius, blast_radius)
	#mesh.scale = Vector3(outer_radius, outer_radius, outer_radius)
	#mesh_core.scale = Vector3(inner_radius, inner_radius, inner_radius)
	#var duplicate_material = mesh.surface_material_override.duplicate()
	#mesh.surface_material_override = duplicate_material
	particle.emitting = true

func _process(delta):
	alpha -= delta * 3.5
	#mesh.surface_material_override.albedo_color.a = alpha
	var cache_clamp = clamp(outer_radius * sin(TIME-timer.time_left), 0, outer_radius)
	mesh.scale = Vector3(cache_clamp, cache_clamp, cache_clamp)
	cache_clamp = clamp(inner_radius * sin(timer.time_left), 0, inner_radius)
	mesh_core.scale = Vector3(cache_clamp, cache_clamp, cache_clamp)

func _on_body_entered(body: Node3D) -> void:
	var knockback_direction = (body.global_position - self.global_position).normalized()
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_transform.origin, body.global_transform.origin)
	query.exclude = [self]
	var collision = space.intersect_ray(query)
	if collision and collision.collider and collision.collider.is_in_group("props"):
		body.linear_velocity = knockback_direction * knockback_amount


func _on_timer_timeout() -> void:
	queue_free()
