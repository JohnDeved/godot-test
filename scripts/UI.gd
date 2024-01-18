extends CanvasLayer

@onready var xp_bar: ProgressBar = %XPBar
@onready var skill_selection: HBoxContainer = %SkillSelection

func _ready() -> void:
	skill_selection.hide()

func _on_player_xp_gained(_amount:int, progress:float) -> void:
		xp_bar.value = progress * 100

func _on_player_level_up(_level:int) -> void:
	xp_bar.value = 100
	get_tree().paused = true
	skill_selection.show()