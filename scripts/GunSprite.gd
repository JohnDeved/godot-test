extends Sprite2D


func _process(_delta):
	var closest_enemy = get_closest_enemy()
	if closest_enemy != null:
		rotate_towards_enemy(closest_enemy)


func get_closest_enemy():
	var closest_enemy = null
	var closest_distance = INF

	for enemy in get_tree().get_nodes_in_group("enemies"):
		var distance = global_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy

	return closest_enemy


func rotate_towards_enemy(enemy):
	var direction = enemy.global_position - global_position
	self.rotation = direction.angle()
	self.flip_v = direction.x < 0
