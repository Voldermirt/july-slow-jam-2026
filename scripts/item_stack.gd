extends Node2D

@export var item_scene: PackedScene = preload("res://scenes/items/test_item.tscn")
@export var vertical_spacing: float = 24.0

var stack: Array[Dictionary] = []

func push_item(item_data: Dictionary) -> void:
	stack.append(item_data)
	_update_visual_stack()

func pop_item(spawn_position: Vector2, throw_velocity: Vector2, facing_dir: int = 0) -> void:
	if stack.is_empty():
		return
		
	var item_data = stack.pop_front()
	
	item_scene = item_data.get("scene")
	if not item_scene:
		return
	
	var new_item = item_scene.instantiate()
	
	# Group dynamically spawned items under a container if one exists
	var container = get_tree().current_scene.find_child("SpawnedItemsContainer", true, false)
	if container:
		container.add_child(new_item)
	else:
		get_tree().current_scene.add_child(new_item)
	
	new_item.global_position = spawn_position
	
	# Initialize physics properties depending on how it was released
	if new_item is BaseItem:
		if facing_dir != 0:
			# Intentionally placed/dropped by the player
			new_item.drop(facing_dir)
		else:
			# Accidentally knocked off the player's stack
			new_item.knock_down(throw_velocity)
			
	_update_visual_stack()

func _update_visual_stack() -> void:
	for child in get_children():
		child.queue_free()
	for i in range(stack.size()):
		var placeholder = Sprite2D.new()
		var item_data = stack[i]
		placeholder.texture = item_data.get("texture", preload("res://icon.svg"))
		placeholder.scale = Vector2(0.5, 0.5)
		placeholder.position = Vector2(0, -i * vertical_spacing)
		add_child(placeholder)

func get_stack_height() -> int:
	return stack.size()
