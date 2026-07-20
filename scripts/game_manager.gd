extends Node
class_name Game

@export var max_game_time_seconds := 120.0
@export var main_scene : PackedScene
@export var day_over_screen : PackedScene

var game_time_left : float
var game_running := false

var can_pause := false
var unloaded_scene : Node = null

var score := 0
var current_day := 1

@onready var current_scene : Node = $TitleMenu
@onready var pause_menu: Control = $PauseCanvasLayer/PauseMenu
@onready var order_timer: Timer = $OrderTimer
@onready var order_manager: OrderManager = $OrderManager

func _ready() -> void:
	game_time_left = max_game_time_seconds

func _input(event: InputEvent) -> void:
	if can_pause and event.is_action_pressed("pause"):
		set_pause(!get_tree().paused)

func _process(delta: float) -> void:
	if game_running:
		game_time_left -= delta
		print(game_time_left)
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
	new_scene.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(new_scene)
	current_scene = new_scene

func restore_scene():
	if not unloaded_scene:
		push_error("Can't restore nonexistent scene!")
		return
	
	current_scene.queue_free()
	await get_tree().process_frame
	add_child(unloaded_scene)
	current_scene = unloaded_scene

func start_game():
	change_scene_to_packed(main_scene)
	
	await get_tree().process_frame
	order_manager.create_order()
	order_timer.start()
	game_running = true
	can_pause = true

func end_game():
	game_running = false
	can_pause = false
	set_pause(false) # Just to be sure ?
	order_timer.stop()
	
	change_scene_to_packed(day_over_screen)
	await get_tree().process_frame
	current_scene.connect("continue_game", _on_continue_pressed)
	current_scene.set_values(current_day, score)

func reset():
	order_manager.reset()
	game_time_left = max_game_time_seconds
	score = 0
	if unloaded_scene:
		unloaded_scene.queue_free()
		unloaded_scene = null

func _on_order_timer_timeout() -> void:
	order_manager.create_order()

func _on_order_manager_order_fulfilled(value: int) -> void:
	score += value

func _on_continue_pressed():
	reset()
	if current_scene.continue_game.is_connected(_on_continue_pressed):
		current_scene.continue_game.disconnect(_on_continue_pressed)
	current_day += 1
	start_game()
