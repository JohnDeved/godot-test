extends CanvasLayer

@onready var xp_bar: ProgressBar = %XPBar
@onready var skill_selection: HBoxContainer = %SkillSelection
@onready var CardScn := preload("res://CardButton.tscn")

func _ready() -> void:
	skill_selection.hide()

func _on_player_xp_gained(_amount:int, progress:float) -> void:
		xp_bar.value = progress * 100

func clear_skill_selection() -> void:
	for child in skill_selection.get_children():
		child.queue_free()

func _on_skill_button_pressed() -> void: 
	xp_bar.value = 0
	get_tree().paused = false
	skill_selection.hide()

func _on_player_level_up(_level:int) -> void:
	xp_bar.value = 100
	get_tree().paused = true
	clear_skill_selection()
	
	for i in range(4):
		var card: CardButton = CardScn.instantiate()
		skill_selection.add_child(card)
		card.pressed.connect(_on_skill_button_pressed)
		card.card_text = "Skill " + str(i)

	skill_selection.show()