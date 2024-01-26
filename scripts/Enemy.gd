extends Entity
class_name Enemy

@onready var XPDropScn := preload("res://XPDrop.tscn")

@export var SPEED: int = 100

@onready var player: Player = p.get_local_player()
@onready var hit_anim: AnimationPlayer = $HitAnim
@onready var death_anim: AnimationPlayer = $DeathAnim

var force: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var direction := global_position.direction_to(player.global_position)
	velocity = direction * SPEED + force
	force -= force * delta * 20

	move_and_collide(velocity * delta)

func apply_force(_force: Vector2) -> void:
	print("applying force")
	force += _force

func on_death() -> void:
	death_anim.play("death")
	var drop: XPDrop = XPDropScn.instantiate()
	drop.position = global_position
	get_parent().add_child(drop)
	print("spawning xp drop ", drop, " at ", drop.position)

func hurt(_damage: float) -> void:
	health -= _damage
	print(self.name, " has ", health, " health left")
	if health <= 0:
		if self is Enemy:
			on_death()

	hit_anim.play("hit_flash")

# func _on_death_animation_finished(anim_name: StringName) -> void:
# 	if anim_name == "death":
# 		queue_free()

func _on_death_particles_finished() -> void:
	print("queueing free")
	call_deferred("queue_free")