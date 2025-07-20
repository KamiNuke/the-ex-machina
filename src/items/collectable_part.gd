extends RigidBody3D

@onready var area: Area3D = $Area3D

const COLLECT_ITEM = preload("res://src/ui/collect_item.tscn")
var collect_item_instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _integrate_forces(state):
	if collect_item_instance != null:
		if Input.is_action_just_pressed("action"):
			const FORCE = Vector3(0, 500, 0)
			state.apply_force(FORCE)
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_3d_area_entered(area: Area3D) -> void:
	var ent = area.get_parent()
	if ent.is_in_group("player"):
		collect_item_instance = COLLECT_ITEM.instantiate()
		add_child(collect_item_instance)


func _on_area_3d_area_exited(area: Area3D) -> void:
	var ent = area.get_parent()
	if collect_item_instance != null:
		collect_item_instance.queue_free()
		#collect_item_instance = null
