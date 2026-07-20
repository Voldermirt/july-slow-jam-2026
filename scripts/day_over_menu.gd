extends Control

signal continue_game

@onready var day_over_label: Label = $VBoxContainer/DayOverLabel
@onready var score_label: Label = $VBoxContainer/ScoreAccumulatedLabel

func set_values(day_num : int, score : int):
	day_over_label.text = "DAY %s OVER!" % day_num
	score_label.text = "Score: %s" % score

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("continue"):
		continue_game.emit()
	elif event.is_action_pressed("pause"):
		get_tree().quit()
