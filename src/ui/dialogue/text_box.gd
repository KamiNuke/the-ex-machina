extends CanvasLayer

@onready var textbox_container: MarginContainer = $TextboxContainer
@onready var label: Label = $TextboxContainer/MarginContainer/HBoxContainer/Label

const CHAR_READ_RATE = 0.08

var is_finished = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_textbox()
	#add_text("tesdasdsadsadsadat")

func hide_textbox():
	label.text = ""
	textbox_container.hide()

func show_textbox():
	textbox_container.show()

func add_text(next_text):
	is_finished = false
	label.text = next_text
	label.visible_characters = 0
	show_textbox()
	
	var tween = get_tree().create_tween()
	tween.tween_property(label, "visible_characters", next_text.length(), next_text.length() * CHAR_READ_RATE)
	tween.finished.connect(on_tween_finished)


func on_tween_finished():
	is_finished = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
