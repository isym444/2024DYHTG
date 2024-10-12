extends Node

#Constants
const oil_per_factory = 5 #MB millions of barrels per time

#Resources
var money = 10000000 #GBP (10 million) #money can go down as non-residential buildings cost money to operate so they can operate at deficit if you don't sell your oil/energy or price of sell is too low
var energy = 2400 #GW (100GWh average forc city so nough for 24h)
var oil = 5 #MB millions of barrels USA produces 11 MBPD
var materials = 100 #building units (each building requires different amount of materials)
var people = 10
var world_health = 100 #in %
var time_survived = 0 #in seconds

enum bankState {CONSERVATIVE, RISKY, YOLO}

#Buildings
var banks = [] #array of dictionaries {"x":-10,"y":8,"z":3, "risk_tolerance":bankState}
var apartment_buildings = [] #array of dictionaries {"x":-10,"y":8, "z":3}
var oil_pumps = [] #array of dictionaries {"x":-10,"y":8, "z":3}
var materials_factories = [] #array of dictionaries {"x":-10,"y":8, "z":3}
var wind_turbines = [] #array of dictionaries {"x":-10,"y":8, "z":3}
var forests = [] #array of dictionaries {"x":-10,"y":8, "z":3}

#Actions
var cleaning_ocean = 0 #boolean - when set to 1, modify world_health for a period of time then reset to 0

#Dashboard-exclusive variables
var energy_price = 500000 #income for selling 1GWH your energy at a particular time
var oil_price = 500000 #income from selling 1MB
#will also display some info from other variables above

#Deltas
var money_per_time = 0 #from bank investment performance (n.b. extra money will come from selling oil/energy/materials)
var oil_per_time = 0 #from oil_pumps
var materials_per_time = 0 #from materials_factories
var energy_per_time = 0 #from wind_turbines

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var time_passed = 0.0 #in seconds

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	
	if time_passed == 5.0:
		#time management
		time_survived += 5
		time_passed = 0.0
		
		#update Deltas based on number of buildings
		oil_per_time = oil_pumps.size()*oil_per_factory
		materials_per_time
		money_per_time
		
		#resources values updates
		money+=money_per_time
		oil+=oil_per_time
		materials+=materials_per_time
		energy+=energy_per_time
		
		
