extends Control

@onready var score: Label = $Score

func _ready() -> void:
	score.text = "Score: " + str(Player.points).pad_zeros(6)

func _on_menu_button_pressed() -> void:
	Player.reset_all()
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
