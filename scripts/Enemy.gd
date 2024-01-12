extends CharacterBody2D

@export var SPEED = 100

@onready var player: CharacterBody2D = %Player

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED

	move_and_collide(velocity * _delta)
