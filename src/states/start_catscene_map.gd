extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var text_box: CanvasLayer = $TextBox
@onready var timer: Timer = $Timer

var next_scene = preload("res://src/states/default.tscn").instantiate()
var current_dialogue = 0
var timer_started = false

var dialogues = [
	"Well, well, well. I couldn't have imagined I'd see you here...",
	"...",
	"Let me get this straight. Are you sure you want to destroy all of their robots?",
	"It's all I can do. I WILL get my revenge.",
	"Hope you won't regret this decision.",
	"...",
	"...",
	"...I have to go...",
	"Sure..."
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

func play_dialogue():
	timer_started = false
	
	if current_dialogue > dialogues.size() - 1:
		var tree = get_tree()
		var cur_scene = tree.get_current_scene()
		tree.get_root().add_child(next_scene)
		tree.get_root().remove_child(cur_scene)
		tree.set_current_scene(next_scene)
	else:
		text_box.add_text(dialogues[current_dialogue])
		current_dialogue = current_dialogue + 1

func _on_timer_timeout() -> void:
	play_dialogue()
