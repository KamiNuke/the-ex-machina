extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_audio()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_audio():
	$winning.play()

func _on_exit_button_button_up() -> void:
	get_tree().quit()


func _on_return_to_menu_button_up() -> void:
	get_tree().change_scene_to_file("res://src/states/menu.tscn")
