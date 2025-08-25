extends Control

var is_menu = false

var previous_scene : Node
@onready var h_slider: HSlider = $settings/sensitivity_hslider
@onready var sensitivity_label: Label = $settings/sensitivity_label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sensitivity_label.text = str(Global.SENSITIVITY * 100) #multiply by 100 to round numbers
	h_slider.value = Global.SENSITIVITY
	h_slider.min_value = 0.0001
	h_slider.step = 0.0001

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_back_button_up() -> void:
	if is_menu:
		var menu_scene = load("res://src/states/menu.tscn").instantiate()
		Global.change_scene(menu_scene)
	else:
		Global.swap_scene(self, previous_scene)

func _on_h_slider_value_changed(value: float) -> void:
	Global.SENSITIVITY = value
	sensitivity_label.text = str(value * 100) #multiply by 100 to round numbers

func set_previous_scene(scene):
	previous_scene = scene
