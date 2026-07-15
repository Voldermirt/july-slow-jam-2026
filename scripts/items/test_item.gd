class_name TestItem extends BaseItem

func _init() -> void:
	super._init()
	freeze = true

func knock_down(velocity: Vector2) -> void:
	freeze = false
	super.knock_down(velocity)

func drop(direction: int) -> void:
	super.drop(direction)

func on_land() -> void:
	super.on_land()
	sprite.flip_v = true

func on_interact(body) -> void:
	sprite.flip_v = not sprite.flip_v

## Test function that knocks the object down when clicked
#func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if not event.is_action_pressed("interact"):
		#return
	#
	#freeze = false
	#knock_down(Vector2(-1, 0.5) * 200)
	##place(1)
