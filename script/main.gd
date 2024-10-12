extends Node3D

@export var selector:Node3D # The 'cursor'
@export var view_camera:Camera3D # Used for raycasting mouse

var bounds = 10
var plane:Plane # Used for raycasting mouse
var plane_position #used for getting coord


# Called when the node enters the scene tree for the first time.
func _ready():
	plane = Plane(Vector3.UP, Vector3.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var world_position = plane.intersects_ray(
		view_camera.project_ray_origin(get_viewport().get_mouse_position()),
		view_camera.project_ray_normal(get_viewport().get_mouse_position()))
		
	plane_position = Vector3(round(world_position.x), 0, round(world_position.z))
	selector.position = lerp(selector.position, plane_position, delta * 40)

func _unhandled_input(event):
	if(Input.is_action_just_pressed("click")):
		#check for placment conditions
		if(plane_position.x < -bounds or plane_position.x > bounds or plane_position.z < -bounds or plane_position.z > bounds):
			print("out of bounds")
			return
		
		#instantiate selected building
		var building = load("res://scene/building/residentialBuilding.tscn").instantiate()
		building.global_position = plane_position
		# Add the TextureRect to the scene
		add_child(building)
