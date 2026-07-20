extends Node
class_name OrderManager

# Items to draw from when completing orders
@export var item_pool : Array[Item] = []
# Parent node for all the destination nodes
@export var destination_parent : Node = null
@export var max_simultaneous_orders := 3

# Enqueue at end, dequeue at beginning
var order_queue : Array[Order] = []
var num_completed := 0

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
	if len(order_queue) == destination_parent.get_child_count():
		print("Everyone has already ordered something!")
		return
	
	var order_item := item_pool.pick_random() as Item
	var available_destinations = destination_parent.get_children().filter(func (dest): is_destination_free(dest))
	var order_dest : Node2D = available_destinations.pick_random()
	var new_order := Order.new(order_item, order_dest) # This band has some good songs
	
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
	pass

class Order: # Family genus species
	var item : Item
	var destination : Node2D
	
	func _init(p_item : Item, p_dest : Node2D) -> void:
		item = p_item
		destination = p_dest
