extends Control

var next_scene = preload("res://src/states/default.tscn").instantiate();

func _on_start_button_up() -> void:
	var tree = get_tree()
	var cur_scene = tree.get_current_scene()
	tree.get_root().add_child(next_scene)
	tree.get_root().remove_child(cur_scene)
	tree.set_current_scene(next_scene)


func _on_exit_button_up() -> void:
	get_tree().quit()
