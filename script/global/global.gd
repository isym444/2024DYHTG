extends Node

#Constants for production per 5 seconds
const oil_per_factory = 1 #MB millions of barrels per time
const materials_per_factory = 5 #building units
const energy_per_turbine = 5 #GW

const bank_building_cost = 3000000
const apartment_building_cost = 3000000
const oil_pump_building_cost = 3000000
const materials_factory_cost = 3000000
const wind_turbine_building_cost = 3000000
const forest_building_cost = 3000000

#Resources
var money = 10000000 #GBP (10 million) #money can go down as non-residential buildings cost money to operate so they can operate at deficit if you don't sell your oil/energy or price of sell is too low
var energy = 2400 #GW (100GWh average forc city so nough for 24h)
var oil = 5 #MB millions of barrels USA produces 11 MBPD
var materials = 100 #building units (each building requires different amount of materials)
var people = 10
var world_health = 1000 #in arbitrary units
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
func add_bank(x_value, y_value, z_value, risk_tolerance_value: bankState)->void:
	if(money-bank_building_cost<0):
		#LUCA TO ADD SIGNAL
		return
	var new_bank = bank_template.duplicate() # Duplicate the template to avoid modifying the original
	new_bank["x"] = x_value
	new_bank["y"] = y_value
	new_bank["z"] = z_value
	new_bank["risk_tolerance"] = risk_tolerance_value
	banks.append(new_bank)
	world_health-=50
var risk_performance_map = {bankState.CONSERVATIVE:0, bankState.RISKY:0, bankState.YOLO:0}

var apartment_buildings = [] #array of dictionaries {"x":-10,"y":8, "z":3}
var oil_pumps = [] #array of dictionaries {"x":-10,"y":8, "z":3}
var materials_factories = [] #array of dictionaries {"x":-10,"y":8, "z":3}
var wind_turbines = [] #array of dictionaries {"x":-10,"y":8, "z":3}
var forests = [] #array of dictionaries {"x":-10,"y":8, "z":3}

var building_template = {
	"x": null, 
	"y": null, 
	"z": null, 
}

func new_building_helper(x_value, y_value, z_value)->Dictionary:
	var new_building = building_template.duplicate()
	new_building["x"] = x_value
	new_building["y"] = y_value
	new_building["z"] = z_value
	return new_building

func add_apartment_building(x_value, y_value, z_value)->void:
	if(money-apartment_building_cost<0):
		#LUCA TO ADD SIGNAL
		return
	var new_building=new_building_helper(x_value, y_value, z_value)
	apartment_buildings.append(new_building)
	world_health-=50
	
func add_oil_pumps(x_value, y_value, z_value)->void:
	if(money-oil_pump_building_cost<0):
		#LUCA TO ADD SIGNAL
		return
	var new_building=new_building_helper(x_value, y_value, z_value)
	oil_pumps.append(new_building)
	world_health-=20
	
func add_materials_factories(x_value, y_value, z_value)->void:
	if(money-materials_factory_cost<0):
		#LUCA TO ADD SIGNAL
		return
	var new_building=new_building_helper(x_value, y_value, z_value)
	materials_factories.append(new_building)
	world_health-=100

#Actions
var times_ocean_cleaned = 0 

func clean_ocean()->void:
	money-=100000
	world_health+=50
	times_ocean_cleaned+=1

func normal_distribution(midpoint: float, stddev: float) -> float:
	var u1 = randf()
	var u2 = randf()
	var z0 = sqrt(-2.0 * log(u1)) * cos(2.0 * PI * u2)
	return z0 * stddev + midpoint

#Dashboard-exclusive variables
var energy_price = 500000 #income for selling 1GWH your energy at a particular time
var oil_price = 500000 #income from selling 1MB
var materials_price = 500000 #income from selling 1 unit of materials

#FUNCTION TO UPDATE PRICES OF COMMODITIES BASED ON NUMBER OF YOLO BANKS ETC
func update_comodities()->void:
	var average=0
	var total=0
	for bank in banks:
		total+=abs(risk_performance_map[bank.risk_tolerance_value])
	#average of bank absolute performances is a proxy/indicator of overall volatility i.e. high volatility -> more skewed/extreme average -> can be used to set SD of normal distribution function that determines commodity prices
	average=total/banks.size()
	
	#if your average bank performance is too extreme (further away from 0), then your commodity prices will also be extreme i.e. use it to update your normal distribution S.D.s
	#maximum possible abs(average) will be 2500 so want to *100 and make it never go below 0
	energy_price = max(normal_distribution(500000,abs(average))*100,0) #income for selling 1GWH your energy at a particular time
	oil_price = max(normal_distribution(500000,abs(average))*100,0) #income from selling 1MB
	materials_price = max(normal_distribution(500000,abs(average))*100,0) #income from selling 1 unit of materials

#Deltas
var money_per_time = 0 #from bank investment performance (n.b. extra money will come from selling oil/energy/materials)
var oil_per_time = 0 #from oil_pumps
var materials_per_time = 0 #from materials_factories
var energy_per_time = 0 #from wind_turbines

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func getUpdatedPerformance(risk_tol: bankState) -> int:
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
		
func update_world_health() -> void:
	world_health-=oil_pumps.size()*20
	world_health-=apartment_buildings.size()
	world_health-=materials_factories.size()*10
	world_health-=banks.size()
	world_health+=forests.size()

var time_passed = 0.0 #in seconds
# Called every frame. 'delta' is the elapsed time since the previous frame

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
		
		#update commodities after bank performance is updated
		update_comodities()
		
		#update world health
		update_world_health()
		
		#if(world_health<200):
			#bring up popup warning user health is low
		
		#resources values updates
		money+=money_per_time
		oil+=oil_per_time
		materials+=materials_per_time
		energy+=energy_per_time
		

		
		#if(money<0 || people<0 || world_health<0):
			#ENDGAME
		

#Test function
#func _unhandled_input(event: InputEvent) -> void:
	#if(Input.is_action_just_pressed("test")):
		#print(oil)
		#sell_oil()
		#print(oil)
