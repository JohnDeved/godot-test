extends Node2D

@onready var BulletScn := preload("res://Bullet.tscn")
var e_check := preload("helper/EnemyCheck.gd").new(self)
var p_check := preload("helper/PlayerCheck.gd").new(self)

@onready var player := p_check.get_local_player()
@onready var timer: Timer = $Timer
var can_shoot := true

@onready var gun_sprite: Sprite2D = $GunSprite
@onready var gun_muzzle: Marker2D = $GunSprite/Muzzle

func _physics_process(_delta: float) -> void:
	var closest_enemy := e_check.get_closest_enemy()
	if closest_enemy != null:
		rotate_towards_enemy(closest_enemy)
	
	if Input.is_action_pressed("action_shoot") and can_shoot:
		spawn_bullet()

func spawn_bullet() -> void:
	var bullet: Bullet = BulletScn.instantiate()
	add_child(bullet)

	var muzzle: Marker2D = $GunSprite/Muzzle
	var pos := muzzle.global_position
	var rot := self.rotation + randf_range(-0.1, 0.1) # spread
	bullet.fire(pos, rot)

	# knockback player using rot
	var knockback := Vector2(cos(rot), sin(rot)) * 100 * -1
	player.apply_force(knockback)

	# start timer
	can_shoot = false
	timer.start()

func rotate_towards_enemy(enemy: CharacterBody2D) -> void:
	var direction := enemy.global_position - global_position
	self.rotation = direction.angle()
	gun_sprite.flip_v = direction.x < 0

func _on_timer_timeout() -> void:
	can_shoot = true
