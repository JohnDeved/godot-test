extends Node
class_name PlayerGlobal

func get_local_player() -> Player:
	return get_tree().get_first_node_in_group("player")

func get_local_camera() -> Camera2D:
	return get_local_player().get_node("PlayerCamera")