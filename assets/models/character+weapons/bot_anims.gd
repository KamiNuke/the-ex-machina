extends Node3D

@export var state_playback_path: String
@export var attack_state_name:String
@export var dash_state_name:String
@export var fall_state_name:String
@export var walk_state_name:String
@export var lower_state_name:String
@export var rise_state_name:String
@export var animation_tree: AnimationTree

@export var blend_name: String

func _on_player_controller__attack() -> void:
	var playback = animation_tree.get(state_playback_path) as AnimationNodeStateMachinePlayback
	playback.travel(attack_state_name)

func _on_player_controller_dash() -> void:
	var playback = animation_tree.get(state_playback_path) as AnimationNodeStateMachinePlayback
	playback.travel(dash_state_name)


func _on_player_controller_fall() -> void:
	var playback = animation_tree.get(state_playback_path) as AnimationNodeStateMachinePlayback
	playback.travel(fall_state_name)


func _on_player_controller_walk(input) -> void:
	var playback = animation_tree.get(state_playback_path) as AnimationNodeStateMachinePlayback
	playback.set(walk_state_name, input)


func _on_weapon_manager_2_lower() -> void:
	var playback = animation_tree.get(state_playback_path) as AnimationNodeStateMachinePlayback
	playback.travel(lower_state_name)


func _on_weapon_manager_2_rise() -> void:
	var playback = animation_tree.get(state_playback_path) as AnimationNodeStateMachinePlayback
	playback.travel(rise_state_name)
