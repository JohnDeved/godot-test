class_name PlayerHelper

var this: Node
func _init(_this: Node) -> void:
	this = _this

func get_local_player() -> Player:
	return this.get_tree().get_first_node_in_group("player")

func get_local_camera() -> Camera2D:
	return get_local_player().get_node("PlayerCamera")