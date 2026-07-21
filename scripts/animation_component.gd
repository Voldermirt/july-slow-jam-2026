class_name AnimationComponent
extends Node

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D

func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:
		return
	
	sprite.flip_h = true if move_direction > 0 else false


func handle_move_animation(move_direction: float) -> void:
	handle_horizontal_flip(move_direction)
	
	if move_direction != 0:
		sprite.play("run")
	else:
		sprite.play("idle")


func handle_jump_animation(is_jumping: bool, move_direction: float) -> void:
	if not is_jumping:
		return
	
	if move_direction != 0:
		sprite.play("jump")
	else:
		sprite.play("ass")


func stop_all() -> void:
	sprite.play("idle")
