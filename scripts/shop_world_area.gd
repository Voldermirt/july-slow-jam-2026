extends Node2D

@export var item_data : Item
@onready var display_sprite : Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item_data and display_sprite:
		display_sprite.texture = item_data.texture
		

func _on_interact_component_triggered(interacting_body : Node2D) -> void:
	if not item_data:
		return
	
	if interacting_body.is_in_group("player") and interacting_body.has_method("add_to_stack"):
		interacting_body.add_to_stack(item_data)
		clear_shop_stand()

func clear_shop_stand() -> void:
	item_data = null
	if display_sprite:
		display_sprite.texture = null
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
