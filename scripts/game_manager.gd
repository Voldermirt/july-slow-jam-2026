extends Node
class_name Game

@onready var pause_menu: Control = $PauseCanvasLayer/PauseMenu

var can_pause := false

@onready var current_scene : Node = $TitleMenu

func _input(event: InputEvent) -> void:
	if can_pause and event.is_action_pressed("pause"):
		set_pause(!get_tree().paused)
	

func set_pause(value : bool):
	get_tree().paused = value
	pause_menu.visible = value

func _on_pause_menu_continue_pressed() -> void:
	set_pause(false)

func change_scene_to_packed(to : PackedScene):
	current_scene.queue_free()
	await get_tree().process_frame
	var new_scene := to.instantiate()
	add_child(new_scene)
	current_scene = new_scene
	can_pause = true
