extends CharacterBody2D

const INITIAL_SPEED = 500.0

var speed = INITIAL_SPEED
var screen_size: Vector2
var player_size: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_size = $CollisionShape2D.shape.get_rect().size

func _physics_process(delta: float) -> void:
	var velocity := Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity = Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		velocity = Vector2.RIGHT

	position += velocity * speed * delta
	position = position.clamp(Vector2.ZERO + (player_size / 2), screen_size - (player_size / 2))

func move_to(n_position: Vector2) -> void:
	position = n_position

func update_speed_to_half():
	speed = speed / 2

func set_speed_to_default():
	speed = INITIAL_SPEED

func set_speed_to_half_speed_more():
	speed = speed * 1.5
