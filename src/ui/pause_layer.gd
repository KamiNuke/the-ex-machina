extends CanvasLayer

var settings_scene = preload("res://src/states/settings.tscn").instantiate();

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_button_button_up() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()


func _on_exit_button_button_up() -> void:
	get_tree().quit()


func _on_settings_button_up() -> void:
	if settings_scene.has_method("set_previous_scene"):
		settings_scene.set_previous_scene(self)
	var parent = get_parent()
	parent.remove_child(self)
	parent.add_child(settings_scene)
