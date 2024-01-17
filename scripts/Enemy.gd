extends Entity
class_name Enemy

var p_check := preload("helper/PlayerCheck.gd").new(self)

@export var SPEED: int = 100

@onready var player: Player = p_check.get_local_player()
@onready var hit_anim: AnimationPlayer = $HitAnim
@onready var hit_sound: AudioStreamPlayer2D = $HitSound

var force: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	var direction := global_position.direction_to(player.global_position)
	velocity = direction * SPEED + force
	force -= force * _delta * 20

	move_and_collide(velocity * _delta)

func apply_force(_force: Vector2) -> void:
	print("applying force")
	force += _force

func hurt(_damage: int) -> void:
	health -= _damage
	print(self.name, " has ", health, " health left")
	if health <= 0:
		if self is Enemy:
			queue_free()

	hit_anim.play("hit_flash")
	hit_sound.play()
