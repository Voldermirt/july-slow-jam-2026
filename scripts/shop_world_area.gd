# Acts like a shop manager
extends Node2D

# All possible items to choose from
@export var item_pool : Array[Item] = []
# Whether or not there is extra logic applied to item population
@export var true_random_selection := false
# Parent node for all the item stands
@onready var item_stands: Node2D = $ItemStands
# If we don't want all items completely randomized
var remaining_pool : Array[Item] = []

func _ready() -> void:
	MusicPlayer.play("shop")
	remaining_pool = item_pool.duplicate()
	populate_items()

func get_stands() -> Array[ShopItem]:
	# Gotta make sure they're actually ShopItems
	#return item_stands.get_children().filter(func(child): return child is ShopItem) as Array[ShopItem]
	var stands : Array[ShopItem] = []
	for child : Node2D in item_stands.get_children():
		if child is ShopItem:
			stands.append(child)
	return stands

func get_random_item() -> Item:
	if true_random_selection:
		return item_pool.pick_random()
	
	# Select an item from the pool of remaining items
	var idx = randi_range(0, len(remaining_pool) - 1)
	var item := remaining_pool[idx]
	remaining_pool.remove_at(idx)
	if remaining_pool.is_empty():
		remaining_pool = item_pool.duplicate()
	
	return item

func populate_items() -> void:
	var stands := get_stands()
	for stand in stands:
		var item := get_random_item()
		stand.stock_item(item)
