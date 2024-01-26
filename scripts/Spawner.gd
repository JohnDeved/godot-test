extends Node2D
class_name Spawner

@onready var EnemyScn := preload("res://Enemy.tscn")
@onready var camera := p.get_local_camera()

func _on_timer_timeout() -> void:
	print("Spawning enemy group")
	var group_size := randf_range(1, 5)  # Random group size between 3 and 6

	var camera_pos := camera.global_position

	var angle := randf() * 2 * PI  # Random angle in radians
	var radius: float = randf_range(1000, 1500)  # Random radius between 100 and 200

	var group_center := Vector2(cos(angle), sin(angle)) * radius  # Convert polar coordinates to Cartesian coordinates

	for i in range(group_size):
			var enemy: Enemy = EnemyScn.instantiate()

			var offset_angle := randf() * 2 * PI  # Random angle for the offset
			var offset_radius := randf_range(10, 30)  # Random radius for the offset
			var offset := Vector2(cos(offset_angle), sin(offset_angle)) * offset_radius  # Convert polar coordinates to Cartesian coordinates

			enemy.global_position = camera_pos + group_center + offset
			add_child(enemy)

func _on_second_timer_timeout() -> void:
	($Timer as Timer).wait_time *= (1 - 0.01) # Decrease wait time by 1%
	print("Decreasing wait time to: ", ($Timer as Timer).wait_time)
