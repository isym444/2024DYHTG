extends Node3D

@export var selector:Node3D # The 'cursor'
@export var view_camera:Camera3D # Used for raycasting mouse

var plane:Plane # Used for raycasting mouse


# Called when the node enters the scene tree for the first time.
func _ready():
	plane = Plane(Vector3.UP, Vector3.ZERO)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var world_position = plane.intersects_ray(
		view_camera.project_ray_origin(get_viewport().get_mouse_position()),
		view_camera.project_ray_normal(get_viewport().get_mouse_position()))
		
	var gridmap_position = Vector3(round(world_position.x), 0, round(world_position.z))
	selector.position = lerp(selector.position, gridmap_position, delta * 40)
