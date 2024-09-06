extends Control

@onready var bgm: AudioStreamPlayer = $BGM

func _ready():
	await get_tree().create_timer(0.2).timeout
	bgm.play()

func quit() -> void:
	get_tree().quit()

func start() -> void:
	bgm.stop()
	get_tree().change_scene_to_file("res://scenes/level/level_1.tscn")


func show_credits() -> void:
	pass # Replace with function body.


func goto_options() -> void:
	bgm.stop()
	get_tree().change_scene_to_file("res://scenes/menu/options.tscn")
