extends Node2D
class_name Bullet

@export var SPEED := 800 * m.wpn_speed_perc
@export var DRAG := 10 / m.wpn_drag_perc
@export var DAMAGE := (10 + m.wpn_damage_base) * m.wpn_damage_perc
@export var STEERING_FORCE := 2.5 * m.wpn_steering_perc  # The force with which the bullet steers towards the enemy

var is_fired := false
var direction := Vector2()
var origin := Vector2()
var min_speed := 100

@onready var tracer: Tracer = $Tracer
@onready var player: Player = p.get_local_player()

func _physics_process(delta: float) -> void:
	if is_fired:
		position += direction * SPEED * delta
		var closest_enemy := e.get_closest_enemy(self)
		if closest_enemy:
			var desired_direction := (closest_enemy.global_position - position).normalized()
			direction = direction.lerp(desired_direction, STEERING_FORCE * delta)

		var current_speed := (direction * SPEED).length()
		tracer.modulate = Color(1, 1, 1, 1 - min_speed / current_speed)

		# Apply drag
		SPEED = max(SPEED - DRAG, min_speed)

		if should_despawn():
			queue_free()


func fire(_pos: Vector2, _dir: float) -> void:
	position = _pos
	origin = _pos
	direction = Vector2.RIGHT.rotated(_dir)
	is_fired = true


func should_despawn() -> bool:
	# distance from origin
	return global_position.distance_to(origin) > 10000 or (direction * SPEED).length() < min_speed

func speed_up(val: int = 10) -> void:
	SPEED += val

func _on_bullet_hit(body:Node2D) -> void:
	if body is Enemy:
		var enemy: Enemy = body
		enemy.hurt(DAMAGE)
		enemy.apply_force(direction * SPEED / 2)
		speed_up()
