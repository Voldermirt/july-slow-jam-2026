class_name Item
extends Resource

#@export var name : String
@export var sprite : Texture2D
@export var min_value : int
@export var max_value : int
# ... weight, etc?
@export var instantiated_item : PackedScene
# The actual value for a particular item instance
var value : int

func _init(p_sprite : Texture2D = null, p_min_value := 0, p_max_value := 0, 
		p_instantiated : PackedScene = null):
	sprite = p_sprite
	min_value = p_min_value
	max_value = p_max_value
	instantiated_item = p_instantiated
	
	value = min_value
	
