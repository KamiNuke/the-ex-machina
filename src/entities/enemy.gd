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

var target_location := Vector3.ZERO
const DISTANCE_FROM_PLAYER = 10.0

var is_following = false

func _ready() -> void:
	scatter_timer.wait_time = randf_range(2.0, 4.0)

func _process(delta: float) -> void:
	if HP <= 0:
		queue_free()

func _physics_process(delta: float) -> void:
	#velocity = Vector3.ZERO
	
	# NAVIGATION
	#var next_nav_point = nav_agent.get_next_path_position()
	#velocity = (next_nav_point - global_position).normalized() * SPEED
	#rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)
	#look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	if is_following:
		var to_target = target_location - global_position
		var distance = to_target.length()
		
		if distance > DISTANCE_FROM_PLAYER:
			var next_nav_point = nav_agent.get_next_path_position()
			var desired_velocity = (next_nav_point - global_position).normalized() * SPEED
			
			nav_agent.set_velocity(desired_velocity)
		else:
			#Stop moving when close
			nav_agent.set_velocity(Vector3.ZERO)
			velocity = Vector3.ZERO
		look_at(Vector3(target_location.x, global_position.y, target_location.z), Vector3.UP)
	else:
		var next_nav_point = nav_agent.get_next_path_position()
		var desired_velocity = (next_nav_point - global_position).normalized() * SCATTER_SPEED
		nav_agent.set_velocity(desired_velocity)
		
		const ROTATE_SPEED = 2.0
		rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * ROTATE_SPEED)
		
	move_and_slide()


func update_target_location(new_target_location):
	target_location = new_target_location
	if is_following:
		nav_agent.set_target_position(target_location)

func hit(damage_amount):
	HP -= damage_amount
	print_debug(HP)

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
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
