class_name EnemyCheck

var this: Node2D
func _init(_this: Node2D) -> void:
	this = _this

func get_closest_enemy(radius: float = 350) -> Enemy:
	var closest_enemy: Enemy = null
	var closest_distance := INF

	var space_state := this.get_world_2d().direct_space_state
	var shape := CircleShape2D.new()
	shape.radius = radius

	var shape_query := PhysicsShapeQueryParameters2D.new()
	shape_query.set_shape(shape)
	shape_query.transform = Transform2D(0, this.global_position)
	shape_query.set_collision_mask(1 << 1)  # Assuming enemies are in the second physics layer

	var result := space_state.intersect_shape(shape_query)

	for r in result:
		if r.collider is Enemy:
			var enemy: Enemy = r.collider
			if enemy.is_alive():
				var distance := this.global_position.distance_to(enemy.global_position)
				if distance < closest_distance:
					closest_distance = distance
					closest_enemy = enemy
	
	return closest_enemy
