extends Node

@onready var hud: Control = $HUD
@onready var scene: Node = $Scene
@onready var ball: CharacterBody2D = $Scene/Ball
@onready var paddle: CharacterBody2D = $Scene/Paddle

@onready var paddle_starting_point: Marker2D = $Markers/PaddleStartingPoint
@onready var ball_starting_point: Marker2D = $Markers/BallStartingPoint

@onready var bgm: AudioStreamPlayer = $Scene/BGM

var has_started := false

func _ready() -> void:
	SignalManager.resume_game.connect(resume_game)
	SignalManager.goto_main_menu.connect(goto_main_menu)
	SignalManager.brick_destroyed.connect(compute_points)
	SignalManager.ball_missed.connect(round_lost)
	SignalManager.activate_powerup.connect(activate_powerup)
	get_tree().paused = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start") and not has_started:
		hud.hide_message()
		get_tree().paused = false
		has_started = true
	if event.is_action_pressed("pause") and has_started:
		hud.toggle_pause()
		get_tree().paused = !get_tree().paused

func round_lost():
	await get_tree().create_timer(1).timeout
	var can_continue = decrease_life()
	if can_continue:
		start_new_round()

func decrease_life():
	Player.decrease_life()
	hud.update_lives(Player.lives)
	if Player.lives < 1:
		bgm.stop()
		get_tree().change_scene_to_file("res://scenes/menu/game_over.tscn")
		return false
	return true

func create_new_ball():
	var ball_location = preload("res://scenes/game/ball.tscn")
	ball = ball_location.instantiate()
	scene.add_child(ball)
	ball.move_to(ball_starting_point.position)

func start_new_round():
	get_tree().paused = true
	has_started = false
	create_new_ball()
	paddle.move_to(paddle_starting_point.position)
	hud.show_message()

func resume_game():
	get_tree().paused = false
	
func goto_main_menu():
	get_tree().paused = false
	Player.reset_all()
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func compute_points(points) -> void:
	Player.add_point(points)
	hud.update_points(Player.points)

func activate_powerup(powerup: Global.PowerUpType):
	if ball == null:
		return
	if powerup == Global.PowerUpType.PADDLE_SPEED_DOWN:
		paddle.update_speed_to_half()
		await get_tree().create_timer(5).timeout
		paddle.set_speed_to_default()
	if powerup == Global.PowerUpType.PADDLE_SPEED_UP:
		paddle.set_speed_to_half_speed_more()
		await get_tree().create_timer(5).timeout
		paddle.set_speed_to_default()
	if powerup == Global.PowerUpType.LIFE_UP:
		Player.increase_life()
	if powerup == Global.PowerUpType.LIFE_DOWN:
		decrease_life()
	if powerup == Global.PowerUpType.BALL_SPEED_UP:
		ball.increase_speed()
		await get_tree().create_timer(10).timeout
		ball.reset_speed()
	if powerup == Global.PowerUpType.BALL_SPEED_DOWN:
		ball.decrease_speed()
		await get_tree().create_timer(10).timeout
		ball.reset_speed()
	if powerup == Global.PowerUpType.BALL_SIZE_INCREASE:
		ball.increase_size()
		await get_tree().create_timer(10).timeout
		ball.reset_size()
	if powerup == Global.PowerUpType.BALL_SIZE_DECREASE:
		ball.decrease_size()
		await get_tree().create_timer(10).timeout
		ball.reset_size()
	if powerup == Global.PowerUpType.BALL_MULTIPLIER:
		print("multipricaa")
