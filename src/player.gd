extends Node

@export var lives := 3
@export var points := 0
@export var elapsed_time := 0

func increase_life():
	if lives < 3:
		lives += 1

func decrease_life():
	lives -= 1
	
func add_point(n_points: int):
	points += n_points
	
func reset_points():
	points = 0

func reset_lives():
	lives = 3

func reset_all():
	reset_lives()
	reset_points()
