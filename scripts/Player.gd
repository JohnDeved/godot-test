extends Entity
class_name Player

signal xp_gained(amount: int, progress: float)
signal level_up(level: int)

@export var SPEED := 600
@export var ACCELERATION := 0.1
@export var FRICTION := 0.2
@export var SPEED_ZOOM_FACTOR := 0.15

var current_xp: float = 0
var xp_to_next_level: float = 100
var level := 1

@onready var camera: Camera2D = $PlayerCamera

var force: Vector2 = Vector2.ZERO


# The _physics_process function is called every physics frame
func _physics_process(delta: float) -> void:
	# Calculate the direction based on user input and joystick input
	var direction := get_direction()

	# By default, the speed scale is 1.0
	var speed_scale := 1.0
	# If the joystick is being used, adjust the speed scale
	if direction.length() > 0:
		speed_scale = direction.length()

	# Calculate the target velocity based on the direction and speed scale
	var target_velocity: Vector2 = direction * SPEED * speed_scale
	# Gradually adjust the velocity towards the target velocity
	velocity = velocity.lerp(target_velocity, ACCELERATION)

	# Apply friction if the direction is zero
	if direction.length() == 0:
		velocity -= velocity * FRICTION * delta

	# Calculate the zoom level based on the speed

	velocity += force
	force -= force * delta * 20

	# camera.zoom = get_zoom_level() # should not be affected by force
	# Move the character
	move_and_collide(velocity * delta)


# Function to calculate the direction based on user input and joystick input
func get_direction() -> Vector2:
	var direction := Input.get_vector("action_left", "action_right", "action_up", "action_down")

	var joy_input := Vector2(
		Input.get_joy_axis(0, JoyAxis.JOY_AXIS_LEFT_X),
		Input.get_joy_axis(0, JoyAxis.JOY_AXIS_LEFT_Y)
	)

	if joy_input.length() > 0.2:
		direction += joy_input

	if direction.length() > 0:
		direction = direction.normalized()

	return direction


# Function to calculate the zoom level based on the speeds
func get_zoom_level() -> Vector2:
	var _speed := (velocity - force).length()
	var zoom_level := 1 - SPEED_ZOOM_FACTOR + SPEED_ZOOM_FACTOR * (1 - _speed / (SPEED + 50))
	return Vector2(zoom_level, zoom_level)


func apply_force(_force: Vector2) -> void:
	force += _force


func _on_pickup_range_body_entered(body: Node2D) -> void:
	if body is XPDrop:
		var xp_drop: XPDrop = body
		xp_drop.pickup()

func get_level_progress() -> float:
	var previous_level_xp := get_xp_for_level(level - 1)
	var xp_progress := current_xp - previous_level_xp
	var total_xp_needed: float = xp_to_next_level - previous_level_xp
	return clamp(xp_progress / total_xp_needed, 0, 1)

func get_xp_for_level(_level: int) -> float:
	return (_level ** 2) * 100

func gain_xp(_amount: int) -> void:
	var sound: AudioStreamPlayer2D = $XPSound.duplicate()
	add_child(sound)
	sound.play()
	# free sound after it's done playing
	sound.connect("finished", func() -> void: sound.queue_free())
	xp_gained.emit(_amount, get_level_progress())
	
	current_xp += _amount
	if current_xp >= xp_to_next_level:
		level += 1
		xp_to_next_level = get_xp_for_level(level)
		print("Level up! You are now level ", level)
		level_up.emit(level)
		