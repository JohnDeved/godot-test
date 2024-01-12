extends Node2D

var Bullet = preload("res://Bullet.tscn")


func _process(_delta):
	if Input.is_action_just_pressed("action_shoot"):
		spawn_bullet()


func spawn_bullet():
	var bullet = Bullet.instantiate()
	add_child(bullet)

	#ugly
	var sprite: Sprite2D = get_node("GunSprite")
	var muzzle: Marker2D = sprite.get_node("Muzzle")
	var pos = muzzle.global_position
	var rot = sprite.rotation + randf_range(-0.1, 0.1) # spread
	bullet.fire(pos, rot)