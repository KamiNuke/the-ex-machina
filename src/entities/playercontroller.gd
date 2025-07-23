extends CharacterBody3D

@onready var head: Node3D = $"."
@onready var aim: RayCast3D = $head/cam_pivot/cam_collision/RayCast3D
@onready var camera: Camera3D = $head/cam_pivot/cam_collision/Camera3D
#@onready var spring: SpringArm3D = $head/cam_pivot/cam_collision
@onready var cam_pivot: Node3D = $head/cam_pivot
@onready var boost_left: Timer = $timers/boost_left
@onready var boost_cooldown: Timer = $timers/boost_cooldown
@onready var cooldown_ui: CanvasLayer = $UI/Cooldown
@onready var crosshair: Control = $UI/Crosshair

@export_enum("DEFAULT_LEGS", "NO_LEGS", 
"BASIC_LEGS", "SYMBIOTIC_LEGS", "GOD_LEGS") var player_legs : int = BodyParts.DEFAULT_LEGS



#STATUS VARIABLES
@export var HP = 100
@export var DAMAGE = 20
@export var LIMIT_VIEW_DOWN: int = -65
@export var LIMIT_VIEW_UP: int = 35


#DEBUG

signal _attack

@onready var weapon: Node3D = $WeaponManager2
#var projectile = load("res://src/entities/throwable/projectile.tscn")
#var explosion = load("res://src/entities/explosion.tscn")
#var projectile_instance
#var explosion_instance
#DEBUG

var speed
var WALK_SPEED = player_legs
const BOOST_SPEED = 5.0
var boost_cooldown_time = BodyParts.legs_cooldown[BodyParts.DEFAULT_LEGS]

const JUMP_VELOCITY = 6.5
const SENSIVITY = 0.005

#sine wave part
const CAMERA_SHAKING = 1.4
var BOB_FREQ = CAMERA_SHAKING #how often footsteps happen
const BOB_AMP = 0.02 #how far camera will go
var t_bob = 0.0 #don't touch

#FOV
@export var BASE_FOV = 75.0
const CHANGE_FOV = 1.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSIVITY)

		var rotation_delta = -event.relative.y * SENSIVITY
		cam_pivot.rotation.x = clamp(rotation_delta + cam_pivot.rotation.x, deg_to_rad(LIMIT_VIEW_DOWN), deg_to_rad(LIMIT_VIEW_UP))
		
		#Weapon view
		weapon.rotation.x = clamp(rotation_delta + cam_pivot.rotation.x, deg_to_rad(LIMIT_VIEW_DOWN), deg_to_rad(LIMIT_VIEW_UP))


func _process(delta: float) -> void:
	# Health Points process
	if HP <= 20:
		player_legs = BodyParts.NO_LEGS
		pass
	elif HP <= 0:
		#death screen
		pass
	
	# set walk speed and boost cooldown every frame in case of it being changed
	WALK_SPEED = BodyParts.legs_speed[player_legs]
	boost_cooldown.wait_time = BodyParts.legs_cooldown[player_legs]
	
	update_cooldown_ui()

func update_cooldown_ui():
	var progress: float	
	if boost_cooldown.is_stopped():
		progress = 1.0
	else:
		var elapsed_time = boost_cooldown.wait_time - boost_cooldown.time_left
		progress = elapsed_time / boost_cooldown.wait_time
		progress = clamp(progress, 0.0, 1.0)
	cooldown_ui.get_node("cooldown_texture").material.set_shader_parameter("cooldown_progress", progress)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if aim.is_colliding():
		weapon.look_at(aim.get_collision_point())
	
	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle sprint
	if Input.is_action_just_pressed("shift") and boost_cooldown.is_stopped() and player_legs != BodyParts.NO_LEGS:
		BOB_FREQ = 0.0 # remove camera shaking during boost
		boost_left.start()
		speed = BOOST_SPEED * WALK_SPEED
	elif boost_left.is_stopped():
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
			const SLIDING = 7.5 # the less value the more character slides like on ice
			velocity.x = lerp(velocity.x, direction.x * speed, delta * SLIDING)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * SLIDING)
	else:
		const CONTROL_IN_AIR = 10.0
		velocity.x = lerp(velocity.x, direction.x * speed, delta * CONTROL_IN_AIR)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * CONTROL_IN_AIR)

	#sine wave
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, BOOST_SPEED * 2)
	var target_fov = BASE_FOV + CHANGE_FOV * velocity_clamped
	var covered_distance = delta * 8.0
	camera.fov = lerp(camera.fov, target_fov, covered_distance)
	

	if Input.is_action_pressed("one"):
		weapon.switch_weapon(1)
	
	if Input.is_action_pressed("two"):
		weapon.switch_weapon(2)
		
	if Input.is_action_pressed("three"):
		weapon.switch_weapon(3)
	
	if Input.is_action_pressed("attack"):
		emit_signal("_attack")
		#spawn_explosion()
	

	
	move_and_slide()

func headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	
	return pos

func _on_boost_left_timeout() -> void:
	BOB_FREQ = CAMERA_SHAKING # return camera shaking after boost
	boost_left.stop()
	boost_cooldown.start()


func _on_boost_cooldown_timeout() -> void:
	boost_cooldown.stop()


func hit(damage_amount):
	HP -= damage_amount
