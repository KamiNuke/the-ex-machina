extends CenterContainer

@export var RETICLE_LINES : Array[Line2D]
@export var PLAYER_CONTROLLER : CharacterBody3D
@export var RETICLE_SPEED : float = 0.25 # how quickly lines change
@export var RETICLE_DISTANCE : float = 2.0 # how far crosses moves

@export var DOT_RADIUS = 0.75
@export var DOT_COLOR = Color.WHITE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	adjust_reticle_lines()

func _draw() -> void:
	draw_circle(Vector2(0,0), DOT_RADIUS, DOT_COLOR)

func adjust_reticle_lines() -> void:
	var player_velocity = PLAYER_CONTROLLER.get_real_velocity()
	var pos = Vector2.ZERO
	var speed = player_velocity.length()
	
	RETICLE_LINES[0].position = lerp(RETICLE_LINES[0].position, pos + Vector2(0, -speed * RETICLE_DISTANCE), RETICLE_SPEED)
	RETICLE_LINES[1].position = lerp(RETICLE_LINES[1].position, pos + Vector2(speed * RETICLE_DISTANCE, 0), RETICLE_SPEED)
	RETICLE_LINES[2].position = lerp(RETICLE_LINES[2].position, pos + Vector2(0, speed * RETICLE_DISTANCE), RETICLE_SPEED)
	RETICLE_LINES[3].position = lerp(RETICLE_LINES[3].position, pos + Vector2(-speed * RETICLE_DISTANCE, 0), RETICLE_SPEED)
