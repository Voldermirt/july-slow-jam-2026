extends Node

@onready var pause_menu: Control = $PauseCanvasLayer/PauseMenu

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		set_pause(!get_tree().paused)
		
func set_pause(value : bool):
	get_tree().paused = value
	pause_menu.visible = value

func _on_pause_menu_continue_pressed() -> void:
	#unpause_game()
	set_pause(false)
