extends Node

@onready var hud: Control = $HUD
@onready var scene: Node = $Scene
@onready var ball: CharacterBody2D = $Scene/Ball
@onready var paddle: CharacterBody2D = $Scene/Paddle

@onready var paddle_starting_point: Marker2D = $Markers/PaddleStartingPoint
@onready var ball_starting_point: Marker2D = $Markers/BallStartingPoint

@onready var bgm: AudioStreamPlayer = $Scene/BGM

@onready var ball_location = preload("res://scenes/game/ball.tscn")
@onready var win: AudioStreamPlayer = $Win

@export var next_level: String

const DEFAULT_POWERUP_EXPIRATION_IN_SECONDS := 10

var has_started := false
var can_receive_input := true

func _ready() -> void:
	SignalManager.resume_game.connect(resume_game)
	SignalManager.goto_main_menu.connect(goto_main_menu)
	SignalManager.brick_destroyed.connect(compute_points)
	SignalManager.ball_missed.connect(round_lost)
	SignalManager.activate_powerup.connect(activate_powerup)
	get_tree().paused = true

func _input(event: InputEvent) -> void:
	if not can_receive_input:
		return
	if event.is_action_pressed("start") and not has_started:
		hud.hide_message()
		ball.serve()
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
	var balls_count = get_tree().get_node_count_in_group("balls")	
	if balls_count > 0:
		return
	Player.decrease_life()
	hud.update_lives(Player.lives)
	if Player.lives < 1:
		bgm.stop()
		get_tree().change_scene_to_file("res://scenes/menu/game_over.tscn")
		return false
	return true

func create_new_ball():
	var n_ball = ball_location.instantiate()
	ball = n_ball
	scene.add_child(n_ball)
	n_ball.move_to(ball_starting_point.position)

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
	var brick_count = get_tree().get_node_count_in_group("bricks")
	Player.add_point(points)
	hud.update_points(Player.points)
	if brick_count == 0:
		get_tree().paused = true
		can_receive_input = false
		win.play()
		await win.finished
		get_tree().change_scene_to_file(next_level)

func increase_life():
	Player.increase_life()
	hud.update_lives(Player.lives)

func reset_ball_speed():
	for _ball in get_tree().get_nodes_in_group("balls"): 
		_ball.reset_speed()

func reset_ball_size():
	for _ball in get_tree().get_nodes_in_group("balls"): 
		_ball.reset_size()

func increase_ball_speed():
	for _ball in get_tree().get_nodes_in_group("balls"): 
		_ball.increase_speed()
	await get_tree().create_timer(DEFAULT_POWERUP_EXPIRATION_IN_SECONDS).timeout
	reset_ball_speed()

func decrease_ball_speed():
	for _ball in get_tree().get_nodes_in_group("balls"): 
		_ball.decrease_speed()
	await get_tree().create_timer(DEFAULT_POWERUP_EXPIRATION_IN_SECONDS).timeout
	reset_ball_speed()

func increase_ball_size():
	for _ball in get_tree().get_nodes_in_group("balls"): 
		_ball.increase_size()
	await get_tree().create_timer(DEFAULT_POWERUP_EXPIRATION_IN_SECONDS).timeout
	reset_ball_size()

func decrease_ball_size():
	for _ball in get_tree().get_nodes_in_group("balls"): 
		_ball.decrease_size()
	await get_tree().create_timer(DEFAULT_POWERUP_EXPIRATION_IN_SECONDS).timeout
	reset_ball_size()

func activate_powerup(powerup: Global.PowerUpType):	
	if powerup == Global.PowerUpType.PADDLE_SPEED_DOWN:
		print("Paddle slow")
		paddle.update_speed_to_half()
		await get_tree().create_timer(5).timeout
		paddle.set_speed_to_default()
	if powerup == Global.PowerUpType.PADDLE_SPEED_UP:
		print("Paddle fast")
		paddle.set_speed_to_half_speed_more()
		await get_tree().create_timer(5).timeout
		paddle.set_speed_to_default()
	if powerup == Global.PowerUpType.LIFE_UP:
		print("Life up")
		increase_life()
	if powerup == Global.PowerUpType.LIFE_DOWN:
		print("Life down")
		decrease_life()
	if powerup == Global.PowerUpType.BALL_SPEED_UP:
		print("Ball speed up")
		increase_ball_speed()
	if powerup == Global.PowerUpType.BALL_SPEED_DOWN:
		print("Ball speed down")
		decrease_ball_speed()
	if powerup == Global.PowerUpType.BALL_SIZE_INCREASE:
		print("Ball size increase")
		increase_ball_size()
	if powerup == Global.PowerUpType.BALL_SIZE_DECREASE:
		print("Ball size decrease")
		decrease_ball_size()
	if powerup == Global.PowerUpType.BALL_MULTIPLIER:
		multiply_balls()

func multiply_balls():
	print("Multiply balls")
	for _ball in get_tree().get_nodes_in_group("balls"):
		var ball1 = ball_location.instantiate()
		ball1.global_position = _ball.global_position
		ball1.set_velocity(Vector2(_ball.velocity.x + 0.5, _ball.velocity.y))
		scene.call_deferred("add_child", ball1)
