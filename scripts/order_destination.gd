extends Node2D



func _on_interactable_component_on_interact(player: Player) -> void:
	get_tree().get_first_node_in_group("order_manager").order_destination_interacted(global_position, player)
