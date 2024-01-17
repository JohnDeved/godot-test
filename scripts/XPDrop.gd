extends StaticBody2D
class_name XPDrop

@export var collecting := false
@export var ABSORB_RANGE := 10
@export var SPEED := 300

var p_check := preload("helper/PlayerCheck.gd").new(self)

@onready var sound: AudioStreamPlayer2D = $Sound
@onready var player := p_check.get_local_player()

func _physics_process(delta: float) -> void:
	if collecting:
		# move towards player
		var direction := (player.global_position - position).normalized()
		position += direction * SPEED * delta

		if player.global_position.distance_to(position) < ABSORB_RANGE:
			queue_free()
			player.gain_xp(1)
			collecting = false

func pickup() -> void:
	print("pickup")
	collecting = true
