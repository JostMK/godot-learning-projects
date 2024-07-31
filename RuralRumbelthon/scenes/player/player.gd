extends AnimatableBody2D

enum Actor {PLAYER_1 = 0, PLAYER_2 = 1}

@export var speed = 300.0

@export var config: PlayerConfig

@onready var sprite = %Sprite2D
@onready var audio_player = $AudioStreamPlayer2D

var velocity: Vector2

func ball_hit(ball: Ball):
	var velocity_ratio = ball.velocity.length() / ball.speed
	audio_player.pitch_scale = log(velocity_ratio + 1) / log(2) # log2(r+1)
	
	audio_player.play()

func _ready():
	sprite.self_modulate = config.color
	audio_player.stream = config.ball_hit_audio
	

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis(config.input_up, config.input_down)
	
	if direction:
		velocity.y = direction * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
	position = clamp_position(position + velocity * delta)
	

func clamp_position(pos: Vector2) -> Vector2:
	var yExtend = sprite.get_rect().size.y * sprite.scale.y * scale.y * 0.5
	var yScreenExtend = get_window().size.y * 0.5
	var y = clamp(pos.y, -yScreenExtend + yExtend, yScreenExtend - yExtend)
	return Vector2(pos.x, y)
