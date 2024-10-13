extends Node3D

# Define the range within which the node can move
@export var move_range: Vector3 = Vector3(1, 1, 1)  # X, Y, Z range of movement
@export var move_speed: float = 0.2  # Movement speed

# Target position
var target_position: Vector3

func _ready():
	# Initialize the target position
	set_random_target_position()

func _process(delta):
	# Move towards the target position
	var direction = (target_position - global_transform.origin).normalized()
	var move_distance = move_speed * delta
	global_transform.origin += direction * move_distance
	
	# Flip horizontally based on the X direction
	if direction.x < 0:
		%Sprite3D.flip_h = true  # Flip to face left
	elif direction.x > 0:
		%Sprite3D.flip_h = false   # Flip to face right

	# Check if close enough to the target, then set a new target position
	if global_transform.origin.distance_to(target_position) < move_distance:
		set_random_target_position()

func set_random_target_position():
	# Randomly set a new target position within the defined range
	var random_x = randf_range(-move_range.x, move_range.x)
	var random_y = randf_range(-move_range.y, move_range.y)
	var random_z = randf_range(-move_range.z, move_range.z)
	
	target_position = global_transform.origin + Vector3(random_x, random_y, random_z)
