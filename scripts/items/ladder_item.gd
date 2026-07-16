class_name LadderItem extends BaseItem

const RUNG = preload("res://scenes/items/ladder_rung.tscn")

@export var rung_offset : float = 32.0

@onready var rung_parent: Node2D = $Rungs

func _init() -> void:
	super._init()
	#freeze = true

func _ready() -> void:
	super._ready()

func knock_down(velocity: Vector2) -> void:
	#freeze = false
	super.knock_down(velocity)


func drop(direction: int) -> void:
	super.drop(direction)

func on_land() -> void:
	super.on_land()
	print(item_data)
	if sprite:
		sprite.visible = false
	await get_tree().process_frame
	rotation_degrees = 0 # Idk if this is necessary
	spawn_rungs(item_data.value)
	
func spawn_rungs(num_rungs : int):
	if num_rungs < 1:
		return
		
	for i in range(num_rungs):
		var rung : StaticBody2D = RUNG.instantiate()
		rung.name = "rung%s" % i
		rung.position = Vector2(place_direction, -1) * rung_offset * i
		rung_parent.add_child(rung)
		await get_tree().create_timer(0.1).timeout
		

#func on_interact(body) -> void:
	#sprite.flip_v = not sprite.flip_v

## Test function that knocks the object down when clicked
#func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if not event.is_action_pressed("interact"):
		#return
	#
	#freeze = false
	#knock_down(Vector2(-1, 0.5) * 200)
	##place(1)
