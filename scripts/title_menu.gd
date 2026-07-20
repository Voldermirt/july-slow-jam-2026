extends Control

@onready var credits_panel: Panel = $CreditsPanel


func _on_credits_button_pressed() -> void:
	credits_panel.visible = true


func _on_start_button_pressed() -> void:
	get_tree().get_first_node_in_group("game_manager").start_game()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_credits_panel_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		credits_panel.visible = false


func _on_control_gui_input(event: InputEvent) -> void:
	if event.is_pressed() and credits_panel.visible:
		credits_panel.visible = false
