extends Node2D

@onready var BulletScn := preload("res://Bullet.tscn")
var enemy_check := preload("helper/EnemyCheck.gd").new(self)

func _process(_delta: float) -> void:
	var closest_enemy := enemy_check.get_closest_enemy()
	if closest_enemy != null:
		rotate_towards_enemy(closest_enemy)
	
	if Input.is_action_just_pressed("action_shoot"):
		spawn_bullet()

func spawn_bullet() -> void:
	var bullet: Bullet = BulletScn.instantiate()
	add_child(bullet)

	var muzzle: Marker2D = $GunSprite/Muzzle
	var pos := muzzle.global_position
	var rot := self.rotation + randf_range(-0.1, 0.1) # spread
	bullet.fire(pos, rot)

func rotate_towards_enemy(enemy: CharacterBody2D) -> void:
	var direction := enemy.global_position - global_position
	self.rotation = direction.angle()
	($GunSprite as Sprite2D).flip_v = direction.x < 0
