extends Control

@onready var points_lbl: Label = $MarginContainer/MainVBox/HBoxContainer/Points
@onready var LIFE_TEXTURE_LIST: Array[TextureRect] = [
	$MarginContainer/MainVBox/HBoxContainer/Life1,
	$MarginContainer/MainVBox/HBoxContainer/Life2,
	$MarginContainer/MainVBox/HBoxContainer/Life3
]
@onready var message_margin: MarginContainer = $MarginContainer/MainVBox/MessageMargin
@onready var pause_menu: CanvasLayer = $PauseMenu

const LIFE_FULL_REGION := Rect2(118, 134, 12, 10)
const LIFE_EMPTY_REGION := Rect2(130, 134, 12, 10)

func _ready() -> void:
	update_lives(Player.lives)
	update_points(Player.points)

func hide_message() -> void:
	message_margin.hide()

func show_message() -> void:
	message_margin.show()

func show_pause() -> void:
	pause_menu.show()

func update_points(points: int):
	points_lbl.text = str(points).pad_zeros(6)

func update_lives(new_life_count: int):
	var new_region: Rect2
	for life_texture_idx in len(LIFE_TEXTURE_LIST):
		if new_life_count > life_texture_idx:
			new_region = LIFE_FULL_REGION
		else:
			new_region = LIFE_EMPTY_REGION
		LIFE_TEXTURE_LIST[life_texture_idx].texture.region = new_region
