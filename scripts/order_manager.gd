extends Node
class_name OrderManager

signal order_fulfilled(value : int)

# Items to draw from when completing orders
@export var item_pool : Array[Item] = []
@export var max_simultaneous_orders := 3

# Enqueue at end, dequeue at beginning
var order_queue : Array[Order] = []
var num_completed := 0

var destination_positions : Array[Vector2] = []

@onready var marker_parent: Node2D = $OrderHUD/MarkerParent

func load_destination_positions():
	for dest in get_tree().get_nodes_in_group("order_destination"):
		destination_positions.append(dest.global_position)

func is_destination_free(dest : Vector2):
	for order : Order in order_queue:
		if order.destination == dest:
			return false
	return true

func get_active_orders() -> Array[Order]:
	if len(order_queue) == 0:
		return []
	return order_queue.slice(0, len(order_queue))

func get_order_from_dest(dest : Vector2) -> Order:
	for order : Order in order_queue:
		if order.destination == dest:
			return order
	
	return null

func create_order():
	if len(order_queue) == len(destination_positions):
		print("Everyone has already ordered something!")
		return
	
	var order_item := item_pool.pick_random() as Item
	var available_destinations = []#destinations.filter(func (dest): is_destination_free(dest))
	for d in destination_positions:
		if is_destination_free(d):
			available_destinations.append(d)
	var order_dest : Vector2 = available_destinations.pick_random()
	var new_order := Order.new(order_item, order_dest) # This band has some good songs
	
	print(new_order.destination)
	
	var should_update_hud := len(order_queue) < max_simultaneous_orders
	
	order_queue.append(new_order)
	
	if should_update_hud:
		update_order_hud()

func fulfill_order(order_dest : Vector2):
	num_completed += 1
	
	var completed_order = get_order_from_dest(order_dest)
	if completed_order:
		order_queue.erase(completed_order)
	
	update_order_hud()
	

func order_destination_interacted(order_dest : Vector2, player : Player):
	var order := get_order_from_dest(order_dest)
	if not order:
		return
	var player_top_item := player.get_top_item()
	if not player_top_item:
		return
	
	if order.item.name == player_top_item.name:
		player.remove_top_item()
		fulfill_order(order_dest)
		order_fulfilled.emit(player_top_item.value)

func update_order_hud():
	var markers = marker_parent.get_children() as Array[OrderHudMarker]
	for i in range(max_simultaneous_orders):
		var order : Order
		if i < len(order_queue):
			order = order_queue[i]
		else:
			order = null
		markers[i].set_order(order)

func reset():
	order_queue = []
	destination_positions = []
	num_completed = 0
	for m : OrderHudMarker in marker_parent.get_children():
		m.visible = false
		m.target_order = null

class Order: # Family genus species
	var item : Item
	var destination : Vector2
	
	func _init(p_item : Item, p_dest : Vector2) -> void:
		item = p_item
		destination = p_dest
