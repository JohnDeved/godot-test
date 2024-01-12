extends CharacterBody2D

@export var SPEED = 600
@export var ACCELERATION = 0.1
@export var FRICTION = 0.2
@export var SPEED_ZOOM_FACTOR = 0.15

@onready var camera: Camera2D = get_node("PlayerCamera")


# The _physics_process function is called every physics frame
func _physics_process(delta):
	# Calculate the direction based on user input and joystick input
	var direction = get_direction()

	# By default, the speed scale is 1.0
	var speed_scale = 1.0
	# If the joystick is being used, adjust the speed scale
	if direction.length() > 0:
		speed_scale = direction.length()

	# Calculate the target velocity based on the direction and speed scale
	var target_velocity = direction * SPEED * speed_scale
	# Gradually adjust the velocity towards the target velocity
	velocity = velocity.lerp(target_velocity, ACCELERATION)

	# Apply friction if the direction is zero
	if direction.length() == 0:
		velocity -= velocity * FRICTION * delta

	# Calculate the zoom level based on the speed
	camera.zoom = get_zoom_level()

	# Move the character
	move_and_collide(velocity * delta)


# Function to calculate the direction based on user input and joystick input
func get_direction():
	var direction = Vector2(
		Input.get_action_strength("action_right") - Input.get_action_strength("action_left"),
		Input.get_action_strength("action_down") - Input.get_action_strength("action_up")
	)

	var joy_input = Vector2(
		Input.get_joy_axis(0, JoyAxis.JOY_AXIS_LEFT_X),
		Input.get_joy_axis(0, JoyAxis.JOY_AXIS_LEFT_Y)
	)

	if joy_input.length() > 0.2:
		direction += joy_input

	if direction.length() > 0:
		direction = direction.normalized()

	return direction


# Function to calculate the zoom level based on the speed


func get_zoom_level():
	var speed = velocity.length()
	var zoom_level = 1 - SPEED_ZOOM_FACTOR + SPEED_ZOOM_FACTOR * (1 - speed / (SPEED + 50))
	return Vector2(zoom_level, zoom_level)
