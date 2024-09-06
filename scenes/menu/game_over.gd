extends CanvasLayer

@onready var high_score: Label = $CenterContainer/VBoxContainer/MarginContainer2/HighScore

var score: int

func _ready() -> void:
	score = Player.points
	high_score.text = "High Score: " + str(score).pad_zeros(6)

func to_main_menu() -> void:
	Player.reset_all()
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
