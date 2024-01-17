extends Node2D
class_name Spawner

@onready var EnemyScn := preload("res://Enemy.tscn")
var p_check := preload("helper/PlayerCheck.gd").new(self)
@onready var camera := p_check.get_local_camera()

func _on_timer_timeout() -> void:
	print("Spawning enemy")
	var enemy: Enemy = EnemyScn.instantiate()

	var camera_pos := camera.global_position
	var camera_size := camera.get_viewport_rect().size

	var angle := randf() * 2 * PI  # Random angle in radians
	var radius: float = sqrt(pow(camera_size.x, 2) + pow(camera_size.y, 2)) + 50  # Full length of the diagonal of the viewport plus some offset

	var spawn_pos := Vector2(cos(angle), sin(angle)) * radius  # Convert polar coordinates to Cartesian coordinates

	enemy.global_position = camera_pos + spawn_pos
	add_child(enemy)

