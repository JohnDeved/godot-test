class_name PlayerCheck

var this: Node2D
func _init(_this: Node2D) -> void:
	this = _this

func get_local_player() -> Player:
	return this.get_tree().get_first_node_in_group("player")
