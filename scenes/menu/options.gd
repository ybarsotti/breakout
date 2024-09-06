extends Control

@onready var audio_player_sfx: AudioStreamPlayer = $AudioPlayerSFX
@onready var audio_player_bgm: AudioStreamPlayer = $AudioPlayerBGM

# Master
@onready var master_slider: HSlider = $MarginContainer/VBoxContainer/MasterOption/MasterSlider
@onready var master_volume_string: Label = $MarginContainer/VBoxContainer/MasterOption/MarginContainer/MasterVolumeString
var master_value: float
var master_idx: int
# BGM
@onready var bgm_slider: HSlider = $MarginContainer/VBoxContainer/BGMOption/BGMSlider
@onready var bgm_volume_string: Label = $MarginContainer/VBoxContainer/BGMOption/MarginContainer/BgmVolumeString
var bgm_value: float
var bgm_idx: int
# SFX
@onready var sfx_slider: HSlider = $MarginContainer/VBoxContainer/SFXOption/SFXSlider
@onready var sfx_volume_string: Label = $MarginContainer/VBoxContainer/SFXOption/MarginContainer/SFXVolumeString
var sfx_value: float
var sfx_idx: int

func _ready() -> void:
	master_idx = AudioServer.get_bus_index("Master")
	bgm_idx = AudioServer.get_bus_index("BGM")
	sfx_idx = AudioServer.get_bus_index("SFX")
		
	master_slider.value = db_to_linear(
		AudioServer.get_bus_volume_db(master_idx)
	)
	bgm_slider.value = db_to_linear(
		AudioServer.get_bus_volume_db(bgm_idx)
	)
	sfx_slider.value = db_to_linear(
		AudioServer.get_bus_volume_db(sfx_idx)
	)

func update_bgm_volume(value: float) -> void:
	bgm_volume_string.text = str(int(value)) + "%"
	AudioServer.set_bus_volume_db(
		bgm_idx, linear_to_db(value)
	)

func update_master_volume(value: float) -> void:
	master_volume_string.text = str(int(value)) + "%"
	AudioServer.set_bus_volume_db(
		master_idx, linear_to_db(value)
	)

func update_sfx_volume(value: float) -> void:
	sfx_volume_string.text = str(int(value)) + "%"
	AudioServer.set_bus_volume_db(
		sfx_idx, linear_to_db(value)
	)

func bgm_drag_started() -> void:
	audio_player_bgm.play()

func bgm_drag_ended(value_changed: bool) -> void:
	audio_player_bgm.stop()

func sfx_drag_started() -> void:
	audio_player_sfx.play()

func sfx_drag_ended(value_changed: bool) -> void:
	audio_player_sfx.stop()

func goto_main_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func save() -> void:
	var newConfig = ConfigFile.new()
	newConfig.set_value("SOUND", "MASTER", master_slider.value)
	newConfig.set_value("SOUND", "BGM", bgm_slider.value)
	newConfig.set_value("SOUND", "SFX", sfx_slider.value)
	newConfig.save("user://settings.ini")
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
