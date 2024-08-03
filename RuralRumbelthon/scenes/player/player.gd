extends AnimatableBody2D
class_name Player

enum Actor {
	PLAYER_1 = 0,
	PLAYER_2 = 1
}

@export var speed = 300.0

@export var config: PlayerConfig

@onready var sprite = %Sprite2D
@onready var audio_player = $AudioStreamPlayer2D

var velocity: Vector2

func _ready():
	# we manually move the ball using PhysicsBody2D.move_and_collide()
	sync_to_physics = false

	sprite.self_modulate = config.color
	audio_player.stream = config.ball_hit_audio
	

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis(config.input_up, config.input_down)
	
	if direction:
		velocity.y = direction * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
	var collision = move_and_collide(velocity * delta) as KinematicCollision2D

	# Hit static wall so stop movement
	if collision and collision.get_collider() is StaticBody2D:
		velocity = Vector2.ZERO


func _on_ball_hit(ball: Ball):
	var velocity_ratio = ball.velocity.length() / ball.speed
	audio_player.pitch_scale = log(velocity_ratio + 1) / log(2) # log2(r+1)
	
	audio_player.play()
