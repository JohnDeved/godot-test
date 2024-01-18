extends Node2D

@onready var BulletScn := preload("res://Bullet.tscn")
var e := preload("helper/EnemyHelper.gd").new(self)
var p := preload("helper/PlayerHelper.gd").new(self)

@onready var player := p.get_local_player()
@onready var timer: Timer = $Timer
var can_shoot := true

@onready var gun_sprite: Sprite2D = $GunSprite
@onready var gun_muzzle: Marker2D = $GunSprite/Muzzle

func _process(_delta: float) -> void:
	var closest_enemy := e.get_closest_enemy()
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
	var knockback := Vector2(cos(rot), sin(rot)) * 50 * -1
	player.apply_force(knockback)

	# start timer
	can_shoot = false
	timer.start()

func rotate_towards_enemy(enemy: CharacterBody2D) -> void:
	var joy_input := Vector2(
		Input.get_joy_axis(0, JoyAxis.JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(0, JoyAxis.JOY_AXIS_RIGHT_Y)
	)	

	if joy_input.length() > 0.2:
		self.rotation = joy_input.angle()
		gun_sprite.flip_v = joy_input.x < 0
		return
	
	var direction := enemy.global_position - global_position
	self.rotation = direction.angle()
	gun_sprite.flip_v = direction.x < 0

func _on_timer_timeout() -> void:
	can_shoot = true
