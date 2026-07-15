extends Area2D
class_name ItemOnStack

signal on_collision(direction)

@export var item_data : Item

var num_collisions := 0

func get_is_colliding():
	return num_collisions > 0

func _ready() -> void:
	$Sprite2D.texture = item_data.sprite

func _on_body_entered(body: Node2D) -> void:
	var dir = (global_position - body.global_position).normalized()
	num_collisions += 1
	on_collision.emit(dir)

func _on_body_exited(_body: Node2D) -> void:
	num_collisions -= 1
