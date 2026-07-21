extends Node2D
# I really should make this as 2 different objects/scripts, but I don't care

enum DOOR_MODE {ENTER, EXIT}

@export var door_mode : DOOR_MODE
@export var shop_scene : PackedScene

var game_manager : Game
var player : Player

func _ready() -> void:
	# Oh boy I sure love excessive coupling!
	game_manager = get_tree().get_first_node_in_group("game_manager")
	player = get_tree().get_first_node_in_group("player")

func enter_shop():
	# Simply unload the overworld scene, don't delete it
	# Also keep the player around
	game_manager.change_scene_to_packed(shop_scene, true, true)

func exit_shop():
	# Restore the overworld scene
	game_manager.restore_scene(true)

func _on_interactable_component_on_interact(_player: Player) -> void:
	if door_mode == DOOR_MODE.ENTER:
		player.set_stack_stability(true)
		enter_shop()
	elif door_mode == DOOR_MODE.EXIT:
		player.set_stack_stability(false)
		exit_shop()
