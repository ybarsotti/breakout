extends StaticBody2D

@export var powerup: Global.PowerUpType

func destroy():
	if powerup != null:
		drop_powerup()
	queue_free()

func drop_powerup():
	var powerup_path = preload("res://scenes/game/power_up.tscn")
	var powerup_instance = powerup_path.instantiate()
	powerup_instance.type = powerup
	powerup_instance.global_position = global_position
	get_parent().call_deferred("add_child", powerup_instance)
