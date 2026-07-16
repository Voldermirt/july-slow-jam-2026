extends Area2D

@export_category("Shop Slot Settings")
@export var item_pool: Array[PackedScene] = []

@onready var item_sprite: Sprite2D = $"Item Sprite"

var selected_item_scene: PackedScene # this might wanna be a resource
var item_data: Dictionary = {}
var player_in_range: CharacterBody2D = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	setup_random_item()

func setup_random_item() -> void:
	if item_pool.is_empty():
		push_warning("ShopItem pool is empty!")
		return
		
	selected_item_scene = item_pool.pick_random()
	
	var temp_instance = selected_item_scene.instantiate()
	if temp_instance:
		item_data = {
			"scene": selected_item_scene,
			"value": temp_instance.get("value") if "value" in temp_instance else 5,
			"texture": temp_instance.sprite.texture if (temp_instance.get("sprite") and temp_instance.sprite) else preload("res://icon.svg")
		}
		
		item_sprite.texture = item_data["texture"]
		
		temp_instance.queue_free()

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		buy_item()

func buy_item() -> void:
	if item_data.is_empty():
		return
		
	if player_in_range.has_node("ItemStack"):
		var player_stack = player_in_range.get_node("ItemStack")
		player_stack.push_item(item_data)
		
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = body

func _on_body_exited(body: Node2D) -> void:
	if body == player_in_range:
		player_in_range = null
