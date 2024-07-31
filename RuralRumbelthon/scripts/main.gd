extends Node2D

@export var win_score_amount = 10

@onready var game = %Game
@onready var menu_ui: MenuUI = %MenuUI
@onready var in_game_ui: InGameUI = %InGameUI

var player_1_score = 0
var player_2_score = 0

func _ready():
	game.score.connect(increase_score)
	menu_ui.start.connect(start)
	menu_ui.quit.connect(quit)
	
	reset()
	menu_ui.set_header("POWER BALL")
	menu_ui.visible = true

func increase_score(actor: Game.Actor):
	match actor:
		Game.Actor.PLAYER_1:
			player_1_score += 1
		Game.Actor.PLAYER_2:
			player_2_score += 1

	in_game_ui.update_score("%d : %d" % [player_1_score, player_2_score])
	
	if player_1_score >= win_score_amount:
		player_wins(Game.Actor.PLAYER_1)
	elif player_2_score >= win_score_amount:
		player_wins(Game.Actor.PLAYER_2)
	

func player_wins(actor: Game.Actor):
	get_tree().process_frame.connect(game.stop, CONNECT_ONE_SHOT)
	menu_ui.visible = true
	
	match actor:
		Game.Actor.PLAYER_1:
			menu_ui.set_header("PLAYER 1 WINS")
		Game.Actor.PLAYER_2:
			menu_ui.set_header("PLAYER 2 WINS")

func start():
	reset()
	game.start()

func quit():
	get_tree().quit()

func reset():
	player_1_score = 0
	player_2_score = 0
	
	menu_ui.visible = false
	in_game_ui.update_score("%d : %d" % [player_1_score, player_2_score])
