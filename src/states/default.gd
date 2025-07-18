extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if !Global.is_paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Global.is_paused = true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Global.is_paused = false
