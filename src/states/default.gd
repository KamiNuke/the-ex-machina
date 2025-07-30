extends Node

@onready var player: CharacterBody3D = $PlayerController
@onready var death_screen: Control = $DeathScreen
@onready var win_layer: Control = $WinLayer

@onready var robot_counter: Label = $UI/VBoxContainer/robot_counter
@onready var revive_counter: Label = $UI/VBoxContainer/revive_counter

const PAUSE_LAYER = preload("res://src/ui/pause_layer.tscn")

signal win

var is_winning_audio_playing = false
var revives_left = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		var pause_instance = PAUSE_LAYER.instantiate()
		add_child(pause_instance)
	var enemy_count = 0
	for child in get_tree().get_nodes_in_group("enemy"):
		if is_instance_valid(child):
			enemy_count += 1
	if enemy_count == 0:
		if !is_winning_audio_playing:
			is_winning_audio_playing = true
			$audio/winning.play()
		win_layer.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		emit_signal("win")
		
	robot_counter.text = "enemies left: " + str(enemy_count)
	revive_counter.text = "revives left: " + str(revives_left)
			
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
	if revives_left > 0:
		for child in get_children():
			if child.is_in_group("enemy"):
				revives_left = revives_left - 1
				enemy_pos = child.position
				is_enemy_found = true
				child.queue_free()
				break;
	
	
	if is_enemy_found:
		player.is_alive = true
		player.restore_model_visibility()
		player.position = enemy_pos
		player.player_legs = BodyParts.SYMBIOTIC_LEGS
		player.HP = 100
		player.enable_collision()
		
		for child in player.get_children():
			if child.has_method("add_ammo_to_each_weapon"):
				child.add_ammo_to_each_weapon(20, 40, 60)
		
		death_screen.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif revives_left <= 0:
		$DeathScreen/text/Label.text = "No revives left"
	else:
		$DeathScreen/text/Label.text = "No robots left"
		pass

func _on_escape_button_up() -> void:
	get_tree().quit()


func _on_winning_finished() -> void:
	is_winning_audio_playing = false
