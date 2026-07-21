extends Control

@onready var progress_bar: ProgressBar = $Control/TimeLeft
@onready var score_label: Label = $ScoreLabel

func update_hud(max_time, time_left, score):
	progress_bar.max_value = max_time
	progress_bar.value = time_left
	score_label.text = " Score: %s " % score
