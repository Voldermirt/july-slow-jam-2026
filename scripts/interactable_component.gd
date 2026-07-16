extends Area2D
class_name Interactable

signal on_interact(player : Player)

func interact(player : Player):
	on_interact.emit(player)
