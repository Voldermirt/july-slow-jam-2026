extends Control

signal continue_pressed

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_continue_button_pressed() -> void:
	continue_pressed.emit()
