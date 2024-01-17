extends Node2D
class_name Spawner

@onready var EnemyScn := preload("res://Enemy.tscn")


func _on_timer_timeout() -> void:
	print("Spawning enemy")
	var enemy: Enemy = EnemyScn.instantiate()
	enemy.position = Vector2(randf_range(0, 800), randf_range(0, 600))
	add_child(enemy)

