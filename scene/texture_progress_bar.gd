extends TextureProgressBar

const MAX_HEALTH = 1000
var health = MAX_HEALTH

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%TextureProgressBar.max_value=MAX_HEALTH


var time_passed = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	#print(time_passed)
	
	if time_passed > 5.0:
		#time management
		time_passed = 0.0
		health=global.world_health
		%TextureProgressBar.value=health
