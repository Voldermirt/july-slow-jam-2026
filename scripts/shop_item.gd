extends Area2D
@export var item_name = "Test Shop Item"
@export var item_resource: PackedScene

var player_in_range: CharacterBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.has_node("ItemStack"):
		player_in_range = body
		print("player is near: ", item_name)

func _on_body_exited(body: Node2D) -> void:
	if body == player_in_range:
		player_in_range = null
		print("player walked away from: ", item_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		pick_up_item()

func pick_up_item() -> void:
	if player_in_range.item_stack:
		if item_resource:
			var new_item = item_resource.instantiate()
			player_in_range.item_stack.add_child(new_item)
			print("Picked up: ", item_name)
			queue_free()
