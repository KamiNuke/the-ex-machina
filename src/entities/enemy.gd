extends CharacterBody3D

### IMPORTANT
# MESH(NOT CHARACTERBODY3D)
# MUST BE ROTATED 180 DEGREE

# status variables
@export var HP = 100
@export var SPEED = 4.0

# scatter variables
var SCATTER_SPEED = SPEED / 2
const SCATTER_DISTANCE = 50
@onready var scatter_timer: Timer = $timers/scatter_timer

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var jump_timer: Timer = $timers/jump_timer

@onready var weapon: Node3D = $WeaponManager
signal _attack
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var step_timer: Timer = $timers/step_timer

signal dying_applause_signal

var target_location := Vector3.ZERO
const DISTANCE_FROM_PLAYER = 10.0
var circle_angle = 0.0
@export var ROTATION_SPEED = 5.0

var is_circling = false
var is_following = false
var is_jumping = false

const JUMP_VELOCITY = 6.5

func _ready() -> void:
	scatter_timer.wait_time = randf_range(2.0, 4.0)
	weapon.switch_weapon(randi_range(1, 3))
	
	dying_applause_signal.connect(Global.play_applause_on_enemy_death)

func _process(delta: float) -> void:
	if HP <= 0:
		queue_free()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_jumping and is_on_floor() and velocity.y <= 0:
		is_jumping = false
		jump_timer.start()
	
	#velocity = Vector3.ZERO
	
	# NAVIGATION
	#var next_nav_point = nav_agent.get_next_path_position()
	#velocity = (next_nav_point - global_position).normalized() * SPEED
	#rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)
	#look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	if is_following:
		emit_signal("_attack")
		
		weapon.look_at(navigation_agent_3d.get_target_position())
		
		var to_target = target_location - global_position
		var distance = to_target.length()
		var next_nav_point = nav_agent.get_next_path_position()
		var desired_velocity = (next_nav_point - global_position).normalized() * SPEED
			
		if distance > DISTANCE_FROM_PLAYER:
			is_circling = false
			nav_agent.set_velocity(desired_velocity)
		else:
			is_circling = true
			circle_angle += 2.0 * delta
			var circle_offset = Vector3(cos(circle_angle), 0, sin(circle_angle)) * DISTANCE_FROM_PLAYER
			var circle_target = target_location + circle_offset
			
			var to_circle = (circle_target - global_position)
			to_circle.y = 0
			velocity.x = to_circle.normalized().x * SPEED
			velocity.z = to_circle.normalized().z * SPEED
			
		to_target.y = 0 
		var target_angle = atan2(-to_target.x, -to_target.z)
		rotation.y = lerp_angle(rotation.y, target_angle, delta * ROTATION_SPEED)
		#look_at(Vector3(target_location.x, global_position.y, target_location.z), Vector3.UP)
	else:
		var next_nav_point = nav_agent.get_next_path_position()
		var desired_velocity = (next_nav_point - global_position).normalized() * SCATTER_SPEED
		nav_agent.set_velocity(desired_velocity)
		
		const ROTATE_SPEED = 2.0
		rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * ROTATE_SPEED)
		

	var horizontal_velocity = Vector2(velocity.x, velocity.z)
	var is_moving := horizontal_velocity.length() > 0.1

	if is_on_floor() and is_moving:
		if step_timer.is_stopped():
			step_timer.start()
			$AudioStreamPlayer3D.play()

	move_and_slide()


func update_target_location(new_target_location):
	target_location = new_target_location
	if is_following:
		nav_agent.set_target_position(target_location)

func hit(damage_amount):
	HP -= damage_amount
	print("Enemy: ", HP)

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	if not is_jumping and not is_circling:
		velocity.x = safe_velocity.x
		velocity.z = safe_velocity.z
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_following = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_following = false
		scatter()
		
func scatter():
	if !is_following:
		var random_direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))
		var scatter_target = global_position + random_direction * SCATTER_DISTANCE
		nav_agent.set_target_position(scatter_target)
		
		scatter_timer.wait_time = randf_range(2.0, 4.0)
		scatter_timer.start()


func _on_navigation_agent_3d_link_reached(details: Dictionary) -> void:
	if is_on_floor() and not is_jumping and jump_timer.is_stopped():
		velocity.y = JUMP_VELOCITY
		is_jumping = true


func _on_step_timer_timeout() -> void:
	step_timer.stop()


func _on_tree_exiting() -> void:
	emit_signal("dying_applause_signal")
