extends Node2D


const STACK_ITEM := preload("res://scenes/item_on_stack.tscn")

# e.g. 0.15 means 15% easier to fall off, for each item above the first
@export var height_multiplier := 0.15
@export var accel_threshold := 100.0 # Acceleration needed to lose an item
@export var super_threshold := 1000.0 # Acceleration needed to lose ALL items
@export var pop_force := 200.0
@export var dangerous_fall_distance : float = 256.0

@onready var items := $Items

var height := 0

var player_max_speed := 0.0
var player_gravity := 0.0

var player_vel := Vector2.ZERO
var accel := 0.0

func set_player_velocity(vel : Vector2):
	#accel = ((player_vel - vel).length())
	
	# Okay so I want it to use just horizontal acceleration for acceleration normally
	# HOWEVER if the player has fallen sufficiently far,
	# Then the acceleration should be set such that things fall off the stack
	var fall_distance = 0.0
	if vel.y == 0 and abs(player_vel.y) > 0:
		# Player has fallen
		fall_distance = (player_vel.y * player_vel.y) / (2.0 * player_gravity)
	if fall_distance >= dangerous_fall_distance:
		if fall_distance >= dangerous_fall_distance * 2:
			accel = super_threshold
		else:
			accel = accel_threshold
	else:
		accel = abs(player_vel.x - vel.x)
	
	player_vel = vel

func set_player_max_speed(speed : float) -> void:
	player_max_speed = speed

func set_player_gravity(gravity : float) -> void:
	player_gravity = gravity

func push_item(item_data : Item) -> void:
	#var last_item = get_top_item()
	# Add new item
	var new_item = STACK_ITEM.instantiate() as ItemOnStack
	new_item.item_data = item_data
	new_item.name = "Item_%s" % str(height)
	new_item.position.y = -28 * (height)
	new_item.on_collision.connect(_on_item_collision.bind(height))
	
	items.add_child(new_item)
	
	height += 1

func pop_item(dir := Vector2.ZERO) -> void:
	if height == 0:
		return
	print("POP!")
	var stack_item = get_top_item()
	var item_data = stack_item.item_data as Item
	var new_item_scene = item_data.instantiated_item as PackedScene
	if not new_item_scene:
		# Default item scene
		new_item_scene = preload("res://scenes/items/test_item.tscn")
	var new_item = new_item_scene.instantiate() as BaseItem
	new_item.global_position = stack_item.global_position
	new_item.item_data = item_data
	#stack_item.monitoring = false
	#stack_item.monitorable = false
	stack_item.queue_free()
  
	# Group dynamically spawned items under a container if one exists
	var container = get_tree().current_scene.find_child("SpawnedItemsContainer", true, false)
	if not container:
		container = get_tree().current_scene
	
	container.call_deferred("add_child", new_item)
	new_item.knock_down(dir * pop_force)
	
	height -= 1
	

func pop_items(num_items : int, dir := Vector2.ZERO) -> void:
	for i in range(num_items):
		pop_item(dir)

func get_top_item() -> Node2D:
	if height == 0:
		return null
	return items.get_node("Item_%s" % str(height - 1))

func get_height() -> int:
	return height

func _physics_process(_delta: float) -> void:
	if get_adjusted_accel(accel, height) >= accel_threshold:
		# May want to tweak how the super threshold works ?
		var direction = Vector2.UP
		if accel > 10:
			direction = Vector2.RIGHT
		elif accel < 10:
			direction = Vector2.LEFT
		pop_items(height if accel >= super_threshold else 1, direction)
	#print(accel)

func _process(delta: float) -> void:
	# A sort of swaying animation
	var dir = -1 if player_vel.x > 0 else 1
	# Normally up to 20 degrees, 35 degrees maximum
	var target_angle = dir * min(abs(player_vel.x) / player_max_speed * 20.0, 35.0)
	rotation_degrees = lerp(rotation_degrees, target_angle, delta * 5)

func _on_item_collision(direction : Vector2, item_height : int) -> void:
	#var adjusted_accel = get_adjusted_accel(info.get_collider_velocity().length(), item_height)
	#if adjusted_accel >= accel_threshold:
		## The hit item, and all above it, should fall off
		#pop_items(height - item_height)
	# For each item, make sure it's actually still colliding
	pop_items(height - item_height, direction)

func get_adjusted_accel(p_accel : float, p_height : int) -> float:
	return p_accel * (((p_height - 1) * height_multiplier) + 1)

func drop_voluntarily(dir : Vector2) -> void: # If false: right
	dir = dir.rotated(randf_range(-0.25, 0.25)) # Range of nearly 15 degrees either way
	pop_item(dir)

### DEBUG PURPOSES ###
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		push_item(preload("res://items/test_item.tres"))
