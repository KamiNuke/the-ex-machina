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
@onready var step_timer: Timer = $timers/step_timer
@onready var weapon_switch_sound: Timer = $timers/weapon_switch_sound
@onready var win_camera: Camera3D = $win_camera
@onready var animation_player: AnimationPlayer = $AnimationPlayer



@export_enum("DEFAULT_LEGS", "NO_LEGS", 
"BASIC_LEGS", "SYMBIOTIC_LEGS", "GOD_LEGS") var player_legs : int = BodyParts.DEFAULT_LEGS



#STATUS VARIABLES
@export var HP = 100
@export var DAMAGE = 20
@export var LIMIT_VIEW_DOWN: int = -65
@export var LIMIT_VIEW_UP: int = 35

var is_alive = true
@onready var model_3d: MeshInstance3D = $MeshInstance3D

var is_win = false
var win_cam_angle := 0.0
const win_cam_radius := 5.0
const win_cam_height := 2.0


#DEBUG

signal _attack
signal player_death

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

func _ready() -> void:
	animation_player.play("start_catscene")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and is_alive and !is_win:
		head.rotate_y(-event.relative.x * SENSIVITY)

		var rotation_delta = -event.relative.y * SENSIVITY
		cam_pivot.rotation.x = clamp(rotation_delta + cam_pivot.rotation.x, deg_to_rad(LIMIT_VIEW_DOWN), deg_to_rad(LIMIT_VIEW_UP))
		
		#Weapon view
		weapon.rotation.x = clamp(rotation_delta + cam_pivot.rotation.x, deg_to_rad(LIMIT_VIEW_DOWN), deg_to_rad(LIMIT_VIEW_UP))


func _process(delta: float) -> void:
	# Health Points process
	if HP <= 0 and is_alive:
		print("cooked")
		disable_collision()
		is_alive = false
		model_3d.visible = false
		emit_signal("player_death")
	elif HP < 20:
		#death screen
		player_legs = BodyParts.NO_LEGS
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
	if not is_on_floor() and is_alive:
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
	
	var is_moving := input_dir.length() > 0.1
	
	if is_on_floor() and is_moving:
		if step_timer.is_stopped():
			step_timer.start()
			$AudioStreamPlayer3D.play()
	
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
	cam_pivot.transform.origin = headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, BOOST_SPEED * 2)
	var target_fov = BASE_FOV + CHANGE_FOV * velocity_clamped
	var covered_distance = delta * 8.0
	camera.fov = lerp(camera.fov, target_fov, covered_distance)
	
	if is_win:
		win_cam_angle += delta * 1.0
		var offset = Vector3(
			cos(win_cam_angle) * win_cam_radius,
			win_cam_height,
			sin(win_cam_angle) * win_cam_radius
		)
		win_camera.global_position = global_position + offset
		win_camera.look_at(global_position + Vector3(0, 1.5, 0), Vector3.UP)


	if Input.is_action_pressed("one"):
		weapon.switch_weapon(1)
		if weapon_switch_sound.is_stopped():
			$WeaponSwitch.play()
			weapon_switch_sound.start()
	
	if Input.is_action_pressed("two"):
		weapon.switch_weapon(2)
		if weapon_switch_sound.is_stopped():
			$WeaponSwitch.play()
			weapon_switch_sound.start()
		
	if Input.is_action_pressed("three"):
		weapon.switch_weapon(3)
		
		if weapon_switch_sound.is_stopped():
			$WeaponSwitch.play()
			weapon_switch_sound.start()

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
	print("Player: ", HP)
	HP -= damage_amount

func add_hp(hp_amount):
	HP += hp_amount

func restore_model_visibility():
	model_3d.visible = true

func disable_collision():
	$CollisionShape3D.disabled = true
	$CollectableArea/CollisionShape3D.disabled = true
	
func enable_collision():
	$CollisionShape3D.disabled = false
	$CollectableArea/CollisionShape3D.disabled = false
	


func _on_step_sound_timeout() -> void:
	step_timer.stop()


func _on_weapon_switch_sound_timeout() -> void:
	weapon_switch_sound.stop()


func _on_default_win() -> void:
	is_win = true
	win_camera.current = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start_catscene":
		$start_camera.current = false
