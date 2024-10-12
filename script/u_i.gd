extends Control

@onready var world_health_label = %worldHealth
@onready var money_label = %money
@onready var people_label = %people
@onready var oil_label = %oil
@onready var energy_label = %energy
@onready var materials_label = %materials

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_text_labels()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_text_labels()
	
func update_text_labels() -> void:
	world_health_label.text = "World health: " + str(global.world_health)
	money_label.text = "Money: " + str(global.money)
	people_label.text = "People: " + str(global.people)
	oil_label.text = "Oil: " + str(global.oil)
	energy_label.text = "Energy: " + str(global.energy)
	
func _on_add_residential_pressed() -> void:
	global.currentBuilding = 0
	
func _on_add_investment_pressed() -> void:
	global.currentBuilding = 1

func _on_add_marshall_pressed() -> void:
	global.currentBuilding = 2

func _on_add_oil_pressed() -> void:
	global.currentBuilding = 3

func _on_add_forest_pressed() -> void:
	global.currentBuilding = 4

func _on_add_wind_pressed() -> void:
	global.currentBuilding = 5
