extends Node3D

@export var selector:Node3D # The 'cursor'
@export var view_camera:Camera3D # Used for raycasting mouse

var bounds = 10
var plane:Plane # Used for raycasting mouse
var plane_position #used for getting coord

var buildingPlacment = []

# Called when the node enters the scene tree for the first time.
func _ready():
	plane = Plane(Vector3.UP, Vector3.ZERO)
	global.cantBuild.connect(blockBuild)
	for i in range(-bounds,bounds+1):
		var row = []
		for j in range(-bounds,bounds+1):
			row.append(-1)
		buildingPlacment.append(row)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var world_position = plane.intersects_ray(
		view_camera.project_ray_origin(get_viewport().get_mouse_position()),
		view_camera.project_ray_normal(get_viewport().get_mouse_position()))
		
	plane_position = Vector3(round(world_position.x), 0, round(world_position.z))
	selector.position = lerp(selector.position, plane_position, delta * 40)

func _input(event):
	if(Input.is_action_just_pressed("test")):
		print(buildingPlacment)
	if(Input.is_action_just_pressed("click")):
		print(global.canBuild)
		#check for placment conditions
		if(plane_position.x < -bounds or plane_position.x > bounds or plane_position.z < -bounds or plane_position.z > bounds):
			print("out of bounds")
			return
		if(buildingPlacment[plane_position.x][plane_position.z] != -1):
			print("building already placed there")
			return
		var building
		if(global.canBuild==false): #making building block once popup alert is triggered
			global.canBuild = true
			return
		#instantiate selected building
		match global.currentBuilding:
			0:
				building = load("res://scene/building/residentialBuilding.tscn").instantiate()
				global.add_apartment_building(plane_position.x,plane_position.y,plane_position.z)
			1:
				building = load("res://scene/building/investmentBank.tscn").instantiate()
				global.add_bank(plane_position.x,plane_position.y,plane_position.z,global.bankState.RISKY)
			2:
				building = load("res://scene/building/marshallWace.tscn").instantiate()
				global.add_bank(plane_position.x,plane_position.y,plane_position.z,global.bankState.RISKY)
			3:
				building = load("res://scene/building/oilPump.tscn").instantiate()
				global.add_oil_pumps(plane_position.x,plane_position.y,plane_position.z)
			4:
				building = load("res://scene/building/forest.tscn").instantiate()
				global.add_forest(plane_position.x,plane_position.y,plane_position.z)
			5:
				building = load("res://scene/building/windTurbine.tscn").instantiate()
				global.add_wind_turbine(plane_position.x,plane_position.y,plane_position.z)
		
		if(global.canBuild==false): #making building block once popup alert is triggered
			global.canBuild = true
			return
		print("building placed")
		buildingPlacment[plane_position.x][plane_position.z] = global.currentBuilding
		building.global_position = plane_position
		# Add the TextureRect to the scene
		add_child(building)


func blockBuild():
	print("building blocked")
	global.canBuild = false
