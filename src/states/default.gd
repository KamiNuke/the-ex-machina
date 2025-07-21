extends Node

@onready var player: CharacterBody3D = $PlayerController

const PAUSE_LAYER = preload("res://src/ui/pause_layer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		var pause_instance = PAUSE_LAYER.instantiate()
		add_child(pause_instance)
			
func _physics_process(delta: float) -> void:
	get_tree().call_group("enemy", "update_target_location", player.global_position)
