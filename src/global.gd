extends Node

@onready var applause_stream = preload("res://assets/sound/killing_applause.wav")

func play_applause_on_enemy_death() -> void:
	var audio = AudioStreamPlayer.new()
	audio.stream = applause_stream
	
	get_tree().root.add_child(audio)
	audio.play()
	
	audio.finished.connect(audio.queue_free)
