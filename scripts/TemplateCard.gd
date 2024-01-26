extends Button
class_name CardButton

@onready var text_node: RichTextLabel = find_child("text")
@onready var img_node: TextureRect = find_child("img")

@export var card_text: String:
	get: return text_node.text
	set(value): text_node.text = value

@export var card_img: Texture2D:
	get: return img_node.texture
	set(value): img_node.texture = value