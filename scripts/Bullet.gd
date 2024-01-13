class_name Bullet
extends Node2D

@export var is_fired := false
@export var direction := Vector2()
@export var speed := 1200
@export var damage := 1
@export var origin := Vector2()
@export var steering_force := .5  # The force with which the bullet steers towards the enemy
@export var min_speed := 100

@onready var tracer: Line2D = $Tracer
var enemyCheck := preload("helper/EnemyCheck.gd").new()

func _physics_process(delta: float) -> void:
	if is_fired:
		position += direction * speed * delta
		var closest_enemy := enemyCheck.get_closest_enemy(self)
		if closest_enemy:
			var desired_direction := (closest_enemy.global_position - global_position).normalized()
			direction = direction.lerp(desired_direction, steering_force * delta)

		var current_speed := (direction * speed).length()
		tracer.modulate = Color(1, 1, 1, 1 - min_speed / current_speed)

		if should_despawn():
			queue_free()


func fire(_pos: Vector2, _dir: float) -> void:
	position = _pos
	origin = _pos
	direction = Vector2.RIGHT.rotated(_dir)
	is_fired = true


func should_despawn() -> bool:
	# distance from origin
	return position.distance_to(origin) > 10000 or (direction * speed).length() < min_speed
