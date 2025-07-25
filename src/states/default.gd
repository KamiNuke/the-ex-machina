extends Node

@onready var player: CharacterBody3D = $PlayerController
@onready var death_screen: Control = $DeathScreen

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
	if is_instance_valid(player):
		get_tree().call_group("enemy", "update_target_location", player.global_position)


#var death_screen = preload("res://src/states/death_screen.tscn");

func _on_player_controller_player_death() -> void:
	death_screen.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#add_child(death_screen.instantiate())
	#tree.get_root().add_child(next_scene)
	#tree.get_root().remove_child(cur_scene)
	#tree.set_current_scene(next_scene)

func _on_reborn_button_up() -> void:
	var enemy_pos
	var is_enemy_found = false
	for child in get_children():
		if child.is_in_group("enemy"):
			enemy_pos = child.position
			is_enemy_found = true
			child.queue_free()
			break;
	
	if is_enemy_found:
		player.is_alive = true
		player.restore_model_visibility()
		player.position = enemy_pos
		player.player_legs = BodyParts.DEFAULT_LEGS
		player.HP = 100
		player.enable_collision()
		death_screen.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		#say that no robots left
		$DeathScreen/text/Label.text = "No robots left"
		pass

func _on_escape_button_up() -> void:
	get_tree().quit()
