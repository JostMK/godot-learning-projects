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
	_spawn_ball(randi() % 2) # randomly selects player that serves


func stop():
	if ball:
		ball.queue_free()


func _player_scored(actor: Actor):
	score.emit(actor)
	
	ball.name = "DELETED"
	ball.queue_free()
	
	call_deferred("_spawn_ball", actor)


func _spawn_ball(actor_serving: Actor) -> void:
	ball = ball_scene.instantiate() as Ball

	match actor_serving:
		Actor.PLAYER_1:
			ball.velocity = _rand_dir_between(-30, 30) * ball.target_speed # to the right
		Actor.PLAYER_2:
			ball.velocity = _rand_dir_between(150, 210) * ball.target_speed # to the left

	add_child(ball)
	ball.global_position = Vector2.ZERO


func _rand_dir_between(min_degree: float, max_degree: float) -> Vector2:
	var min_rad = min_degree / 180 * PI
	var max_rad = max_degree / 180 * PI
	return Vector2.from_angle(min_rad + randf() * (max_rad - min_rad))
