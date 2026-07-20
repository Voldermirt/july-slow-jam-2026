extends Node
class_name OrderManager

# Items to draw from when completing orders
@export var item_pool : Array[Item] = []
@export var max_simultaneous_orders := 3

# Enqueue at end, dequeue at beginning
var order_queue : Array[Order] = []
var num_completed := 0

@onready var marker_parent: Node2D = $OrderHUD/MarkerParent

func is_destination_free(dest : Node2D):
	for order : Order in order_queue:
		if order.destination == dest:
			return false
	
	return true

func get_active_orders() -> Array[Order]:
	if len(order_queue) == 0:
		return []
	return order_queue.slice(0, len(order_queue))

func get_order_from_dest(dest : Node2D) -> Order:
	for order : Order in order_queue:
		if order.destination == dest:
			return order
	
	return null

func create_order():
	var destinations := get_tree().get_nodes_in_group("order_destination")
	print(destinations)
	if len(order_queue) == len(destinations):
		print("Everyone has already ordered something!")
		return
	
	var order_item := item_pool.pick_random() as Item
	var available_destinations = []#destinations.filter(func (dest): is_destination_free(dest))
	for d in destinations:
		if is_destination_free(d):
			available_destinations.append(d)
	var order_dest : Node2D = available_destinations.pick_random()
	var new_order := Order.new(order_item, order_dest) # This band has some good songs
	
	print(new_order.destination)
	
	var should_update_hud := len(order_queue) < max_simultaneous_orders
	
	order_queue.append(new_order)
	
	if should_update_hud:
		update_order_hud()

func fulfill_order(order_dest : Node2D):
	num_completed += 1
	
	var completed_order = get_order_from_dest(order_dest)
	if completed_order:
		order_queue.erase(completed_order)
	
	update_order_hud()

func update_order_hud():
	var markers = marker_parent.get_children() as Array[OrderHudMarker]
	for i in range(max_simultaneous_orders):
		var order : Order
		if i < len(order_queue):
			order = order_queue[i]
		else:
			order = null
		markers[i].set_order(order)

class Order: # Family genus species
	var item : Item
	var destination : Node2D
	
	func _init(p_item : Item, p_dest : Node2D) -> void:
		item = p_item
		destination = p_dest
