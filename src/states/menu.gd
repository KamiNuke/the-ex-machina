extends Control

var next_game_scene = preload("res://src/states/start_catscene_map.tscn").instantiate();
var settings_scene_packed = preload("res://src/states/settings.tscn");

func _on_start_button_up() -> void:
	Global.change_scene(next_game_scene)


func _on_exit_button_up() -> void:
	get_tree().quit()


func _on_settings_button_up() -> void:
	#if SETTINGS_SCENE.has_method("set_prev_scene"):
	#	pass
	var settings_scene = settings_scene_packed.instantiate()
	settings_scene.is_menu = true
	Global.change_scene(settings_scene)
