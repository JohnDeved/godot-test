extends StaticBody2D
class_name XPDrop

@export var collecting := false
@export var ABSORB_RANGE := 10
@export var SPEED := 300
@export var XP := 10

@onready var sound: AudioStreamPlayer2D = $Sound
@onready var player := p.get_local_player()

func _physics_process(delta: float) -> void:
	if collecting:
		# move towards player
		var direction := (player.global_position - position).normalized()
		position += direction * SPEED * delta

		if player.global_position.distance_to(position) < ABSORB_RANGE:
			queue_free()
			player.gain_xp(XP)
			collecting = false

func pickup() -> void:
	print("pickup")
	collecting = true
