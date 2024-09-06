extends CanvasLayer

func resume() -> void:
	SignalManager.resume_game.emit()
	hide()

func goto_main_menu() -> void:
	SignalManager.goto_main_menu.emit()
	hide()
