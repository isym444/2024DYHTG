extends Node3D

var camera_position:Vector3
var camera_rotation:Vector3

var rotationInc:int = 90
var zoomInc:int = 20
@export var view_camera:Camera3D

func _ready():
	
	camera_rotation = rotation_degrees # Initial rotation
	
	pass

func _process(delta):
	
	# Set position and rotation to targets
	
	position = position.lerp(camera_position, delta * 8)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 6)
	
	handle_input(delta)

# Handle input

func handle_input(delta):
	
	#movement of camera
	var input := Vector3.ZERO
	
	input.z = Input.get_axis("camera_left", "camera_right")
	input.x = Input.get_axis("camera_back", "camera_forward")
	
	input = input.rotated(Vector3.UP, rotation.y+40).normalized()
	
	camera_position += input / 4

	#rotation of camera
	if Input.is_action_just_pressed("rotateLeft"):
		camera_rotation -= Vector3(0, -rotationInc, 0)
		
	if Input.is_action_just_pressed("rotateRight"):
		camera_rotation += Vector3(0, -rotationInc, 0)
	
	# Back to center
	if Input.is_action_pressed("camera_center"):
		camera_position = Vector3()
		
		
	#zoom of camera
	if Input.is_action_just_pressed("camera_zoom_in"):
		view_camera.fov = lerp(view_camera.fov, view_camera.fov-zoomInc, delta * 5)
	if Input.is_action_just_pressed("camera_zoom_out"):
		view_camera.fov = lerp(view_camera.fov, view_camera.fov+zoomInc, delta * 5)
		
