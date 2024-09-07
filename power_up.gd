extends StaticBody2D

const POWER_UP_REGION: Dictionary = {
	Global.PowerUpType.PADDLE_SPEED_DOWN: Rect2(0, 0, 16, 15),
	Global.PowerUpType.PADDLE_SPEED_UP: Rect2(16, 0, 16, 15),
	Global.PowerUpType.LIFE_UP: Rect2(32, 0, 16, 15),
	Global.PowerUpType.LIFE_DOWN: Rect2(48, 0, 16, 15),
	Global.PowerUpType.BALL_SPEED_UP: Rect2(64, 0, 16, 15),
	Global.PowerUpType.BALL_SPEED_DOWN: Rect2(80, 0, 16, 15),
	Global.PowerUpType.BALL_SIZE_DECREASE: Rect2(96, 0, 16, 15),
	Global.PowerUpType.BALL_SIZE_INCREASE: Rect2(112, 0, 16, 15),
	Global.PowerUpType.BALL_MULTIPLIER: Rect2(128, 0, 16, 15),
}

@export var type: Global.PowerUpType

@onready var sprite_2d: Sprite2D = $Sprite2D

const SPEED = 150

func _ready() -> void:
	sprite_2d.region_rect = POWER_UP_REGION[type]

func _process(delta: float) -> void:
	position += Vector2.DOWN * SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func activate_powerup(body: Node2D) -> void:
	if body is CharacterBody2D:
		SignalManager.activate_powerup.emit(type)
		queue_free()
