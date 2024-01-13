extends Line2D

@export var MAX_POINTS := 20
@onready var curve := Curve2D.new()

func _physics_process(_delta: float) -> void:
	var bullet: Node2D = get_parent()
	curve.add_point(bullet.position)
	if curve.get_point_count() > MAX_POINTS:
		curve.remove_point(0)
		
	points = curve.get_baked_points()

