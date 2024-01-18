extends Node2D
class_name Bullet

var e_check := preload("helper/EnemyCheck.gd").new(self)
var p_check := preload("helper/PlayerCheck.gd").new(self)

@export var is_fired := false
@export var direction := Vector2()
@export var SPEED := 800
@export var DRAG := 10
@export var DAMAGE := 10
@export var origin := Vector2()
@export var steering_force := 2.5  # The force with which the bullet steers towards the enemy
@export var min_speed := 100

@onready var tracer: Tracer = $Tracer
@onready var player: Player = p_check.get_local_player()

func _physics_process(delta: float) -> void:
	if is_fired:
		position += direction * SPEED * delta
		var closest_enemy := e_check.get_closest_enemy()
		if closest_enemy:
			var desired_direction := (closest_enemy.global_position - position).normalized()
			direction = direction.lerp(desired_direction, steering_force * delta)

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
