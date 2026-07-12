extends BaseItem

@export_category("Properties")
@export var place_speed: float = 5.0

func knock_down(velocity: Vector2) -> void:
	if not on_stack: # item has already been dropped
		return
	
	on_stack = false
	linear_velocity = velocity
	angular_velocity = 1

func place(direction: int) -> void:
	if not on_stack:
		return
	
	on_stack = false
	linear_velocity = Vector2(1, -0.5) * place_speed
