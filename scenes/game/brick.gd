@tool
extends StaticBody2D

var powerup: Global.PowerUpType
var lives := 1
@onready var sprite_2d: Sprite2D = $Sprite2D

enum Type {
	NORMAL,
	STRONG,
}

@export var color: BColor
@export var type: Type

enum BColor {
	BLUE_GREEN,
	BLUE_PURPLE,
	BLUE_BLACK,
	BLACK_RED,
	ORANGE_PURPLE,
	ORANGE
}

const Region: Dictionary = {
	BColor.BLUE_GREEN: Rect2(48, 8, 32, 16),
	BColor.BLUE_PURPLE: Rect2(120, 8, 32, 16),
	BColor.BLUE_BLACK: Rect2(192, 8, 32, 16),
	BColor.BLACK_RED: Rect2(192, 48, 32, 16),
	BColor.ORANGE_PURPLE: Rect2(264, 8, 32, 16),
	BColor.ORANGE: Rect2(8, 128, 32, 16),	
}

const POWERUP_PROB = 3

func _ready():
	define_lives()
	define_default_color()
	set_powerup_if_needed()
	
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if type == Type.NORMAL:
			sprite_2d.region_rect = Region[color]
		if type == Type.STRONG:
			sprite_2d.region_rect = Region[BColor.ORANGE]

func define_default_color():
	if type == Type.NORMAL:
		sprite_2d.region_rect = Region[color]
	if type == Type.STRONG:
		sprite_2d.region_rect = Region[BColor.ORANGE]

func define_lives():
	if type == Type.NORMAL:
		lives = 1
	if type == Type.STRONG:
		lives = 3

func hit():
	lives -= 1
	if lives < 1:
		destroy()

func destroy():
	SignalManager.brick_destroyed.emit(150)
	if powerup != Global.PowerUpType.NONE:
		drop_powerup()
	queue_free()

func drop_powerup():
	var powerup_path = preload("res://scenes/game/power_up.tscn")
	var powerup_instance = powerup_path.instantiate()
	powerup_instance.type = powerup
	powerup_instance.global_position = global_position
	get_parent().call_deferred("add_child", powerup_instance)

func set_powerup(n_powerup: Global.PowerUpType):
	powerup = n_powerup

func set_powerup_if_needed():
	if should_have_powerup():
		powerup = get_random_powerup()
	else:
		powerup = Global.PowerUpType.NONE

func get_random_powerup() -> int:
	return Global.PowerUpType.values()[randi() % Global.PowerUpType.size()]

func should_have_powerup() -> bool:
	return randi_range(0, 10) < POWERUP_PROB
