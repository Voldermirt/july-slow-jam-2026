class_name BaseItem extends RigidBody2D
## This is the abstract base class of the Item hierarchy. 
##
## Contains the attributes common to all items (weight and value), tracks the 
## item's state, and provides abstract methods for derived classes to implement 
## which define the item's behavior when dropped, placed, and interacted with.

@export_category("Item Attributes") # exported for testing
@export_range(0.0, 2.0, 0.1) 	var weight: float = 1.0
@export_range(0, 10, 1) 		var value: int = 5

@export_category("Child Nodes")
@export var sprite: Sprite2D
@export var collision: CollisionShape2D

# States
# on_stack: whether the item is currently on the stack.
# is_placed: whether the item has been placed.
# If neither are true, then the item is falling.
var on_stack: bool
var is_placed: bool

## Override in derived class to set item attributes when object is created via
## .new()
func _init() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
	#TODO handle gravity if on_stacked and is_placed are both false

## Called when the item is instantiated while being knocked off the stack.
## Args:
## 		velocity: The input velocity of the item being knocked off. 
func knock_down(velocity: Vector2) -> void:
	pass


## Called when the item is instantiated while being placed. This is 
## Args:
## 		direction: The direction the player is facing. 0 = left, 1 = right.
##		player_velocity: The player's velocity at the moment the item is placed.
func place(direction: int) -> void:
	pass

## Called when the item lands and stops moving.
func on_land() -> void:
	pass
