extends CharacterBody2D
class_name Entity

@export var speed: float = 100
@export var health: float = 100
@export var base_damage: float = 10

func is_alive() -> bool:
    return health > 0

func is_dead() -> bool:
    return health <= 0