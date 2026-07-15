extends Node2D
class_name ShopItem

@export_category("Shop Slot Settings")
# May remove this later; I figure the pool of items should be determined by the shop manager?
@export var item_pool: Array[PackedScene] = []

@onready var item_sprite: Sprite2D = $ItemSprite

@export var item_data: Item = null

func stock_item(new_item : Item) -> void:
	if not new_item:
		return
	
	item_data = new_item
	item_sprite.texture = item_data.sprite
	# Set the actual value
	item_data.value = randi_range(item_data.min_value, item_data.max_value)

func buy_item(player : Player) -> void:
	if not item_data:
		return
	
	player.add_item(item_data)
	item_sprite.visible = false
	
	item_data = null

func _on_interact(player: Player) -> void:
	buy_item(player)
