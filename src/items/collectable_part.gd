extends RigidBody3D

#@onready var area: Area3D = $Area3D

enum type{
	bodypart,
	ammo
}

@export var collectable_type = type.bodypart

const COLLECT_ITEM = preload("res://src/ui/collect_item.tscn")
var collect_item_instance
var player_instance

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D


# for physics after equipping an item
var rng = RandomNumberGenerator.new()

@export_enum("DEFAULT_LEGS", "NO_LEGS", 
"BASIC_LEGS", "SYMBIOTIC_LEGS", "GOD_LEGS") var body_legs : int = BodyParts.GOD_LEGS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func swap_parts() -> void:
	var temp = player_instance.player_legs
	player_instance.player_legs = body_legs
	body_legs = temp
	audio_stream_player_3d.play()

func add_ammo():
	for child in player_instance.get_children():
		if child.has_method("add_ammo_to_each_weapon"):
			child.add_ammo_to_each_weapon(10, 20, 30)

func _integrate_forces(state):
	if collect_item_instance != null:
		if Input.is_action_just_pressed("action"):
			var FORCE = Vector3(rng.randi_range(-2500, 2500), 40000, rng.randi_range(-2500, 2500))
			state.apply_force(FORCE)
			if collectable_type == type.bodypart:
				swap_parts()
				if body_legs == BodyParts.NO_LEGS:
					player_instance.add_hp(40)
					self_destroy()
			elif collectable_type == type.ammo:
				add_ammo()
				self_destroy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func self_destroy():
	$hitbox.disabled = true
	$Area3D/CollisionShape3D.disabled = true
	$Sprite3D.texture = null
	audio_stream_player_3d.play()
	await get_tree().create_timer(.50).timeout
	queue_free()

func _on_area_3d_area_entered(area: Area3D) -> void:
	var ent = area.get_parent()
	if ent.is_in_group("player"):
		player_instance = ent
		collect_item_instance = COLLECT_ITEM.instantiate()
		add_child(collect_item_instance)

func _on_area_3d_area_exited(area: Area3D) -> void:
	#var ent = area.get_parent()
	if is_instance_valid(collect_item_instance):
		collect_item_instance.queue_free()
		#collect_item_instance = null
