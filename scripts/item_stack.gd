extends Node2D
@export var item_scene : PackedScene = preload("res://scenes/items/test_item.tscn")
@export var vertical_gap : float = 24.0
@export var base_knock_off_threshold : float = 600.0

# stack holds item data
var stack : Array[Dictionary] = []

func push_item(item_data : Dictionary) -> void:
	stack.append(item_data)
	_update_visual_stack()

func pop_item(spawn_position : Vector2, throw_velocity : Vector2) -> void:
	if stack.is_empty():
		return
	
	var item_data = stack.pop_front()
	
	var new_item = item_scene.instantiate() as BaseItem
	get_tree().current_scene.add_child(new_item)
	new_item.global_position = spawn_position
	
	new_item.weight = item_data.get("weight", 1.0)
	new_item.value = item_data.get("value", 10)
	
	new_item.on_dropped(throw_velocity)
	_update_visual_stack()

func _update_visual_stack() -> void:
	for child in get_children():
		child.queue_free()
	
	for i in range(stack.size()):
		var placeholder = Sprite2D.new()
		placeholder.texture = preload("res://icon.svg")
		placeholder.scale = Vector2(0.5, 0.5)
		placeholder.position = Vector2(0, -i * vertical_gap)
		add_child(placeholder)

func get_total_weight() -> float:
	var total = 0.0
	for item in stack:
		total += item.get("weight", 1.0)
	return total

func get_stack_height() -> int:
	return stack.size()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
