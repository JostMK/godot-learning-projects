extends CenterContainer
class_name MenuUI

signal start
signal quit

@onready var game_over_label = %GameOverLabel
@onready var start_button = %StartButton
@onready var quit_button: Button = %QuitButton

func _ready():
	start_button.pressed.connect(start.emit.bind())
	quit_button.pressed.connect(quit.emit.bind())

func set_header(text: String):
	game_over_label.text = text
