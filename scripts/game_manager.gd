extends Node
class_name Game

@export var max_game_time_seconds := 120.0

var game_time_left : float
var game_runnng := false

var can_pause := false
var unloaded_scene : Node = null

@onready var current_scene : Node = $TitleMenu
@onready var pause_menu: Control = $PauseCanvasLayer/PauseMenu

func _ready() -> void:
	game_time_left = max_game_time_seconds

func _input(event: InputEvent) -> void:
	if can_pause and event.is_action_pressed("pause"):
		set_pause(!get_tree().paused)

func _process(delta: float) -> void:
	if game_runnng:
		game_time_left -= delta
		if game_time_left <= 0.0:
			end_game()

func set_pause(value : bool):
	get_tree().paused = value
	pause_menu.visible = value

func _on_pause_menu_continue_pressed() -> void:
	set_pause(false)

func change_scene_to_packed(to : PackedScene, unload_current := false):
	if unload_current:
		unloaded_scene = current_scene
		remove_child(current_scene)
	else:
		current_scene.queue_free()
	await get_tree().process_frame
	var new_scene := to.instantiate()
	add_child(new_scene)
	current_scene = new_scene
	can_pause = true

func restore_scene():
	if not unloaded_scene:
		push_error("Can't restore nonexisted scene!")
		return
	
	current_scene.queue_free()
	await get_tree().process_frame
	add_child(unloaded_scene)
	current_scene = unloaded_scene

func start_game():
	pass

func end_game():
	pass
