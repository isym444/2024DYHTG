extends Node

#Constants for production per 5 seconds
const oil_per_factory = 1 #MB millions of barrels per time
const materials_per_factory = 5 #building units
const energy_per_turbine = 5 #GW

#Resources
var money = 10000000 #GBP (10 million) #money can go down as non-residential buildings cost money to operate so they can operate at deficit if you don't sell your oil/energy or price of sell is too low
var energy = 2400 #GW (100GWh average forc city so nough for 24h)
var oil = 5 #MB millions of barrels USA produces 11 MBPD
var materials = 100 #building units (each building requires different amount of materials)
var people = 10
var world_health = 1000 #in %
var time_survived = 0 #in seconds

enum bankState {CONSERVATIVE, RISKY, YOLO}

#Buildings
var bank_template = {
	"x": null, 
	"y": null, 
	"z": null, 
	"risk_tolerance": null
}
var banks = [] #array of dictionaries {"x":-10,"y":8,"z":3, "risk_tolerance":bankState}
func create_bank(x_value, y_value, z_value, risk_tolerance_value: bankState)->void:
	var new_bank = bank_template.duplicate() # Duplicate the template to avoid modifying the original
	new_bank["x"] = x_value
	new_bank["y"] = y_value
	new_bank["z"] = z_value
	new_bank["risk_tolerance"] = risk_tolerance_value
	banks.append(new_bank)
var risk_performance_map = {bankState.CONSERVATIVE:0, bankState.RISKY:0, bankState.YOLO:0}

var apartment_buildings = [] #array of dictionaries {"x":-10,"y":8, "z":3}
var oil_pumps = [] #array of dictionaries {"x":-10,"y":8, "z":3}
var materials_factories = [] #array of dictionaries {"x":-10,"y":8, "z":3}
var wind_turbines = [] #array of dictionaries {"x":-10,"y":8, "z":3}
var forests = [] #array of dictionaries {"x":-10,"y":8, "z":3}

#Actions
var times_ocean_cleaned = 0 

func clean_ocean()->void:
	money-=100000
	world_health+=50
	times_ocean_cleaned+=1

#Dashboard-exclusive variables
var energy_price = 500000 #income for selling 1GWH your energy at a particular time
var oil_price = 500000 #income from selling 1MB
var materials_price = 500000 #income from selling 1 unit of materials
#VOLATITLIY FUNCTION TO UPDATE PRICES BASED ON NUMBER OF YOLO BANKS ETC
#will also display some info from other variables above

#Deltas
var money_per_time = 0 #from bank investment performance (n.b. extra money will come from selling oil/energy/materials)
var oil_per_time = 0 #from oil_pumps
var materials_per_time = 0 #from materials_factories
var energy_per_time = 0 #from wind_turbines

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func normal_distribution(midpoint: float, stddev: float) -> float:
	var u1 = randf()
	var u2 = randf()
	var z0 = sqrt(-2.0 * log(u1)) * cos(2.0 * PI * u2)
	return z0 * stddev + midpoint

func getUpdatedPerformance(risk_tol: bankState) -> int:
	#Still need to make the logic for generating a random standard deviation for performance of stock. At moment just hardcoded
	if(risk_tol==bankState.CONSERVATIVE):
		return max(normal_distribution(3,1),0)
	if(risk_tol==bankState.RISKY):
		return normal_distribution(8,10)
	if(risk_tol==bankState.YOLO):
		var riskfactor = randi_range(1, 10) #1 to 10 inclusive
		if(riskfactor>9):#i.e. 1/10 of the time
			return normal_distribution(50,100)*10
		return normal_distribution(50,100)
	return 0

# Functions for selling stuff and updating money based on this -> to make implementation simpler, only allow selling one unit per click of button
func sell_oil() -> void:
	if(oil>0):
		money+=energy_price
		oil-=1

func sell_materials() -> void:
	if(materials>0):
		money+=materials_price
		materials-=1

func sell_energy() -> void:
	if(energy>0):
		money+=materials_price
		energy-=50

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
		materials_per_time = materials_factories.size()*materials_per_factory
		energy_per_time = wind_turbines.size()*energy_per_turbine
		
		for bank in banks:
			#update risk tolerance
			risk_performance_map[bank.risk_tolerance]=getUpdatedPerformance(bank.risk_tolerance)
			#use updated risk tolerance of each bank to update your money_per_time
			money_per_time += risk_performance_map[bank.risk_tolerance]
		
		#resources values updates
		money+=money_per_time
		oil+=oil_per_time
		materials+=materials_per_time
		energy+=energy_per_time
		
		
