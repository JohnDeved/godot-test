extends ProgressBar

var p_check := preload("helper/PlayerCheck.gd").new(self)
@onready var player := p_check.get_local_player()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var level_progress := player.get_level_progress() * 100
	# print(level_progress)
	self.value = level_progress
