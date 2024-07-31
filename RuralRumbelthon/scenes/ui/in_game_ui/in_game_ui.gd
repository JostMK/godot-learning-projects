extends VBoxContainer
class_name InGameUI

@onready var score_label = %ScoreLabel

func update_score(text: String):
	score_label.text = text
