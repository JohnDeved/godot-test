class_name EnemyCheck

func get_closest_enemy(this: Node2D) -> Enemy:
	var closest_enemy: CharacterBody2D = null
	var closest_distance := INF

	for enemy: CharacterBody2D in this.get_tree().get_nodes_in_group("enemies"):
		var distance := this.global_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	
	return closest_enemy
