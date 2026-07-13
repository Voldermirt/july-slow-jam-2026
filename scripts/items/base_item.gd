class_name BaseItem extends RigidBody2D
## This is the base class of the Item hierarchy that defines the default 
## behavior of an item.
##
## Contains the attributes common to all items (weight and value), tracks the 
## item's state, and provides methods (which derived classes can override) that
## define the item's behavior when dropped, placed, and interacted with.

@export_category("Item Attributes") # exported for testing
## Weight: The weight of the item while on the stack. 
## TODO how does this interact with mass? is this Weven necessary?
#@export_range(0.0, 2.0, 0.1) 	var weight: float = 1.0
## Value: The number of points this item is worth when delivered
@export_range(0, 10, 1) 		var value: int = 5

@export_category("Physics Properties")
## How much the item accelerates when placed.
@export var base_speed: float = 100.0
## The y value for the angle an item gets pushed when placed
@export var place_angle: float = -0.5

@export_category("Child Nodes")
@export var sprite: Sprite2D
@export var collision: CollisionShape2D
@export var interact_area: Area2D


# States
# is_placed: whether the item has been placed.
# If false, then the item is falling.
var is_placed: bool

func _ready() -> void:
	freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
	# Connect signals
	interact_area.body_entered.connect(handle_body_entered)
	sleeping_state_changed.connect(handle_sleeping_state_changed)
	# Set collision layer
	set_collision_layer_value(2, true)
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)
	interact_area.set_collision_layer_value(2, true)
	interact_area.set_collision_mask_value(1, true)
	interact_area.set_collision_mask_value(2, true)

func _init() -> void:
	is_placed = false

## Called when the item is instantiated while being knocked off the stack.
## Args:
## 		velocity: The input velocity of the item being knocked off. 
func knock_down(velocity: Vector2) -> void:
	apply_impulse(velocity)

## Called when the item is instantiated while being intentionally placed.
## Args:
## 		direction: The direction the player is facing. -1 = left, 1 = right.
func drop(direction: int) -> void:
	apply_impulse(Vector2(direction, place_angle) * base_speed)

## Called when the item lands and stops moving. Locks item in place.
func on_land() -> void:
	if is_placed:
		return
	is_placed = true
	set_deferred("freeze", true)
	
## Called when player or other item touches this item.
func on_interact(body) -> void:
	pass

## Called when something collides with the item.
func handle_body_entered(body: Node) -> void:
	if body is CharacterBody2D or body is BaseItem:
		on_interact(body)

## Triggered when the item stops moving for a certain period off time.
func handle_sleeping_state_changed():
	if sleeping:
		on_land()
