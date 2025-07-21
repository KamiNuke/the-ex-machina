extends CharacterBody3D

### IMPORTANT
# MESH(NOT CHARACTERBODY3D)
# MUST BE ROTATED 180 DEGREE

@export var HP = 100
const SPEED = 4.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var target_location := Vector3.ZERO

const DISTANCE_FROM_PLAYER = 10.0

func _ready() -> void:
	pass

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
	move_and_slide()


func update_target_location(new_target_location):
	target_location = new_target_location
	nav_agent.set_target_position(target_location)

func hit(damage_amount):
	HP -= damage_amount
	print(HP)

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	pass
