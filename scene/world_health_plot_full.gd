extends Control

var gwh = global.world_health

# Size of the graph
var graph_width: int = 285
var graph_height: int = 325

# Predefined Y-axis values for the graph (can be dynamically updated)
var y_values: Array = [gwh]  # Example with a variety of values

# Calculate the number of points (up to 5 values)
var num_points: int = 12

# Spacing between points on the X-axis, adjusted for up to 5 values
var x_spacing: float = (graph_width - 50) / float(num_points - 1)  # Subtracting the offset for better spacing

# Offset for the graph origin
var origin_offset: Vector2 = Vector2(50, graph_height - 50)  # Shift the origin closer to the edge

# Dynamic Y-scale values (min and max from the y_values array)
var min_y: float
var max_y: float
var y_scale: float

# Function to calculate the dynamic Y-scale
func calculate_y_scale():
	# Calculate the minimum and maximum values in the y_values array
	min_y = y_values.min()
	max_y = y_values.max()

	# Calculate a dynamic y_scale based on the graph height and the range of Y-values
	var y_range = max_y - min_y
	if y_range == 0:
		y_range = 1  # Prevent division by zero if all values are the same
	y_scale = (graph_height - 100) / y_range  # Subtract some padding for the graph's top/bottom


# Called when the node is added to the scene
func _ready():
	queue_redraw()  # Initial draw


# Function to plot the line graph on the GUI
func _draw():
	# Calculate the Y-scale dynamically before drawing
	calculate_y_scale()

	# Set the graph background color
	draw_rect(Rect2(Vector2(0, 0), Vector2(graph_width, graph_height)), Color(0, 0, 0, 0.2), true)

	# Adjusted origin to align with the actual canvas
	var origin = Vector2(50, graph_height - 50)  # X = 50 for padding, Y is aligned with the bottom of the graph

	# Draw the X-axis and Y-axis at the proper origin
	draw_line(Vector2(50, origin.y), Vector2(graph_width, origin.y), Color(1, 1, 1), 2)  # X-axis
	draw_line(Vector2(50, 0), Vector2(50, graph_height), Color(1, 1, 1), 2)  # Y-axis

	# Draw the line graph based on the predefined y_values array (up to 5 values)
	if y_values.size() > 1:
		for i in range(1, y_values.size()):
			# Adjust the Y-values dynamically based on the calculated y_scale and range
			var prev_y = (y_values[i - 1] - min_y) * y_scale
			var curr_y = (y_values[i] - min_y) * y_scale

			# Adjust the starting point to align with the Y-axis at x = 50
			var prev_point = Vector2(50 + (i - 1) * x_spacing, origin.y - prev_y)
			var curr_point = Vector2(50 + i * x_spacing, origin.y - curr_y)

			# Draw the line between consecutive points
			draw_line(prev_point, curr_point, Color(0, 1, 0), 2)  # Green line for the graph
			

var time=0
func _process(delta):
	queue_redraw()  # Continuously update the graph
	time+=delta
	if(time>5):
		time=0
		if(y_values.size()>10):
			y_values.pop_front()
		y_values.append(global.world_health)
		#print(y_values)
