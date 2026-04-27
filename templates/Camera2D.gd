extends Camera2D

@export var max_move_speed = 500
@export var move_accel = 50

var motion := Vector2()

@export var zoom_speed: float = 0.1  # How fast the zoom changes
var min_zoom: Vector2 = Vector2(0.1, 0.1)  # Minimum allowed zoom
var max_zoom: Vector2 = Vector2(2, 2)  # Maximum allowed zoom

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var move_speed = max_move_speed * (1 / zoom.x)
	var accel = move_accel * (1 / zoom.x)
	if Input.is_action_pressed("move_right"):
		motion.x += accel
	elif Input.is_action_pressed("move_left"):
		motion.x -= accel
	else:
		motion.x = lerpf(motion.x, 0, 0.2)
	
	if Input.is_action_pressed("move_down"):
		motion.y += accel
	elif Input.is_action_pressed("move_up"):
		motion.y -= accel
	else:
		motion.y = lerpf(motion.y, 0, 0.2)
		
	motion.x = clamp(motion.x, -move_speed, move_speed)
	motion.y = clamp(motion.y, -move_speed, move_speed)
			
	position += motion * delta
	
	# Zooming
	# Get the current zoom value
	var current_zoom = zoom

	# Adjust the zoom based on input
	if Input.is_action_pressed("zoom_out"):
		current_zoom.x -= zoom_speed * delta
		current_zoom.y -= zoom_speed * delta
	if Input.is_action_pressed("zoom_in"):
		current_zoom.x += zoom_speed * delta
		current_zoom.y += zoom_speed * delta

	# Clamp the zoom values to ensure they remain between the min and max zoom values
	current_zoom.x = clampf(current_zoom.x, min_zoom.x, max_zoom.x)
	current_zoom.y = clampf(current_zoom.y, min_zoom.y, max_zoom.y)

	# Apply the new zoom value
	zoom = current_zoom

