extends Area2D
class_name Goal

signal ball_entered

func _on_body_entered(_body):
	ball_entered.emit()
