extends CharacterBody3D

@onready var head: Node3D = $"."
@onready var camera: Camera3D = $head/Camera3D

var speed
const WALK_SPEED = 2.5
const SPRINT_SPEED = 5.0

const JUMP_VELOCITY = 6.5
const SENSIVITY = 0.005

#sine wave part
const BOB_FREQ = 1.4 #how often footsteps happen
const BOB_AMP = 0.02 #how far camera will go
var t_bob = 0.0 #don't touch

#FOV
@export var BASE_FOV = 75.0
const CHANGE_FOV = 2.5

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and !Global.is_paused:
		head.rotate_y(-event.relative.x * SENSIVITY)
		camera.rotate_x(-event.relative.y * SENSIVITY)
		const LIMIT_VIEW_DOWN = -25
		const LIMIT_VIEW_UP = 35
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(LIMIT_VIEW_DOWN), deg_to_rad(LIMIT_VIEW_UP))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle sprint
	if Input.is_action_pressed("shift"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		const CONTROL_IN_AIR = 1.0
		velocity.x = lerp(velocity.x, direction.x * speed, delta * CONTROL_IN_AIR)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * CONTROL_IN_AIR)

	#sine wave
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + CHANGE_FOV * velocity_clamped
	var covered_distance = delta * 8.0
	camera.fov = lerp(camera.fov, target_fov, covered_distance)
	
	move_and_slide()

func headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	
	return pos
