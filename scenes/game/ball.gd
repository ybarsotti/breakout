extends CharacterBody2D

@onready var sfx: AudioStreamPlayer = $SFX

var INITIAL_SPEED = 300.0
var speed = INITIAL_SPEED

var direction: Vector2

const BRICK_HIT = preload("res://assets/audio/brick_hit.ogg")
const PADDLE_HIT = preload("res://assets/audio/paddle_hit.ogg")

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * speed * delta)
	if collision:
		if collision.get_collider() is StaticBody2D:
			var collider = collision.get_collider()
			if collider.has_method("hit"):
				collider.hit()
				speed += 3
				
			velocity = velocity.bounce(collision.get_normal())
			sfx.stream = BRICK_HIT
		else:
			var paddle = collision.get_collider() as CharacterBody2D
			velocity = (global_position - paddle.global_position).normalized()
			sfx.stream = PADDLE_HIT
		sfx.play()

func serve():
	velocity = Vector2.DOWN

func move_to(n_position: Vector2) -> void:
	position = n_position
	
func missed() -> void:
	SignalManager.ball_missed.emit()
	queue_free()
	
func increase_speed():
	speed *= 1.5

func reset_speed():
	speed = INITIAL_SPEED

func decrease_speed():
	speed /= 2

func increase_size():
	scale *= 1.2

func reset_size():
	scale = Vector2(1, 1)
	
func decrease_size():
	scale /= 1.2
