extends Node

var SENSITIVITY = 0.0025

@onready var applause_stream = preload("res://assets/sound/killing_applause.wav")

func _ready() -> void:
	if OS.get_name() == "Web":
		SENSITIVITY = 0.0125 #WEB Sensitivity for some reason smaller
	else:
		SENSITIVITY = 0.0025

func play_applause_on_enemy_death() -> void:
	var audio = AudioStreamPlayer.new()
	audio.stream = applause_stream
	
	get_tree().root.add_child(audio)
	audio.play()
	
	audio.finished.connect(audio.queue_free)

func change_scene(next_scene):
	var tree = get_tree()
	var cur_scene = tree.get_current_scene()
	tree.get_root().add_child(next_scene)
	tree.get_root().remove_child(cur_scene)
	cur_scene.queue_free()
	tree.set_current_scene(next_scene)

func swap_scene(self_scene, next_scene):
	var parent = self_scene.get_parent()
	if parent:
		parent.remove_child(self_scene)
		parent.add_child(next_scene)
