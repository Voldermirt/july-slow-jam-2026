extends Node2D

@export var item_scene: PackedScene = preload("res://scenes/items/test_item.tscn")
@export var vertical_spacing: float = 24.0

var stack: Array[Dictionary] = []

func push_item(item_data: Dictionary) -> void:
	stack.append(item_data)
	_update_visual_stack()

func pop_item(spawn_position: Vector2, throw_velocity: Vector2) -> void:
	if stack.is_empty():
		return
		
	var item_data = stack.pop_front() # FIFO stack popping
	
	var new_item = item_scene.instantiate()
	get_tree().current_scene.add_child(new_item)
	new_item.global_position = spawn_position
	
	# Apply properties...
	new_item.on_dropped(throw_velocity)
	_update_visual_stack()

func _update_visual_stack() -> void:
	for child in get_children():
		child.queue_free()
	for i in range(stack.size()):
		var placeholder = Sprite2D.new()
		placeholder.texture = preload("res://icon.svg")
		placeholder.scale = Vector2(0.5, 0.5)
		placeholder.position = Vector2(0, -i * vertical_spacing)
		add_child(placeholder)

func get_stack_height() -> int:
	return stack.size()
