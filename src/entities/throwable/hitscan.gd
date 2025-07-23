extends MeshInstance3D

@onready var spark: GPUParticles3D = $sparks

var alpha: float = 1.0

func _ready():
	var duplicate_material = material_override.duplicate()
	material_override = duplicate_material

func init(pos1, pos2):
	var draw_mesh = ImmediateMesh.new()
	mesh = draw_mesh
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material_override)
	mesh.surface_add_vertex(pos1)
	mesh.surface_add_vertex(pos2)
	draw_mesh.surface_end()

func _process(delta):
	alpha -= delta * 3.5
	material_override.albedo_color.a = alpha

func trigger_particles(pos, gun_pos):
	spark.position = pos
	spark.look_at(gun_pos)
	spark.emiting = true

func _on_timer_timeout() -> void:
	queue_free()
