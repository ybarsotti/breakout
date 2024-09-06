extends CharacterBody2D

@onready var sfx: AudioStreamPlayer = $SFX

const SPEED = 300.0

var direction: Vector2

const BRICK_HIT = preload("res://assets/audio/brick_hit.ogg")
const PADDLE_HIT = preload("res://assets/audio/paddle_hit.ogg")

func _ready() -> void:
	velocity = Vector2.DOWN

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * SPEED * delta)

	if collision:
		if collision.get_collider() is StaticBody2D:
			var collider = collision.get_collider()
			if collider.has_method("destroy"):
				collider.destroy()
				SignalManager.brick_destroyed.emit(100)
				
			velocity = velocity.bounce(collision.get_normal())
			sfx.stream = BRICK_HIT
		else:
			var paddle = collision.get_collider() as CharacterBody2D
			velocity = (global_position - paddle.global_position).normalized()
			sfx.stream = PADDLE_HIT
		sfx.play()

func move_to(n_position: Vector2) -> void:
	position = n_position
	
func missed() -> void:
	SignalManager.ball_missed.emit()
	queue_free()
