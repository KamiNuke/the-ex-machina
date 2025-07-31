extends Node

var next_scene = preload("res://src/ui/win_layer.tscn").instantiate()

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var text_box: CanvasLayer = $TextBox
@onready var timer: Timer = $Timer

var current_dialogue = 0
var timer_started = false

var dialogues = [
	"YOU CRAZY IDIOT. YOU DID IT",
	"Hell yeah I DID IT",
	"However... What now?",
	"Now, I need more... I can't get rid of this feeling.",
	"Oh man. Did you forget?",
	"...",
	"...",
	"Forgot what exactly?",
	"We are ONLY ONE"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("camera_move")
	play_dialogue()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action") and text_box.is_finished:
		timer.stop() 
		timer_started = false
		play_dialogue()
	
	if text_box.is_finished and not timer_started:
		timer.start()
		timer_started = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "camera_move":
		timer.start()
		timer_started = true
	elif anim_name == "end":
		var tree = get_tree()
		var cur_scene = tree.get_current_scene()
		tree.get_root().add_child(next_scene)
		tree.get_root().remove_child(cur_scene)
		tree.set_current_scene(next_scene)

func play_dialogue():
	timer_started = false
	
	if current_dialogue > dialogues.size() - 1:
		animation_player.play("end")
	else:
		text_box.add_text(dialogues[current_dialogue])
		current_dialogue = current_dialogue + 1

func _on_timer_timeout() -> void:
	play_dialogue()
