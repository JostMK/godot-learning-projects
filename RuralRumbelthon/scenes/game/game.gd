extends Node2D
class_name Game

signal score(actor: Actor)

enum Actor {PLAYER_1 = 0, PLAYER_2 = 1}

@export var ball_scene: PackedScene

@onready var goal_player_1 = $GoalPlayer1
@onready var goal_player_2 = $GoalPlayer2

var ball: Ball

func _ready():
	goal_player_1.ball_entered.connect(_player_scored.bind(Actor.PLAYER_2))
	goal_player_2.ball_entered.connect(_player_scored.bind(Actor.PLAYER_1))

func start():
	ball = ball_scene.instantiate() as Ball
	add_child(ball)

func stop():
	if ball:
		ball.queue_free()

func _player_scored(actor: Actor):
	score.emit(actor)
	
	ball.name = "DELETED"
	ball.queue_free()
	
	ball = ball_scene.instantiate() as Ball
	call_deferred("add_child", ball)
