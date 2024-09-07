extends StaticBody2D

var powerup: Global.PowerUpType
# TODO set export

const POWERUP_PROB = 3

func _ready():
	set_powerup_if_needed()

func destroy():
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
		powerup = int(get_random_powerup())
	else:
		powerup = Global.PowerUpType.NONE

func get_random_powerup() -> int:
	return Global.PowerUpType.values()[randi() % Global.PowerUpType.size()]

func should_have_powerup() -> bool:
	return randi_range(0, 10) < POWERUP_PROB
