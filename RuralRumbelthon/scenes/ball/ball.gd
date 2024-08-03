extends AnimatableBody2D
class_name Ball

@export var target_speed: float = 400.
@export var damping_bounce_count: int = 3
@export var repel_force: float = 100.

var velocity: Vector2

var _bounce_count: int = 0
var _player_collision_layer_id = -1

func _ready():
	# we manually move the ball using PhysicsBody2D.move_and_collide()
	sync_to_physics = false

	_find_player_collision_layer()


func _physics_process(delta):
	var move_amount = velocity * delta

	# collide up to 10 bounces
	for __ in 10:
		var collision = move_and_collide(move_amount) as KinematicCollision2D

		if not collision:
			break

		move_amount = _handle_collision_physics(collision)
		
		if collision.get_collider().has_method("_on_ball_hit"):
			collision.get_collider().call("_on_ball_hit", self)
	

func _handle_collision_physics(collision: KinematicCollision2D) -> Vector2:
	# reflect velocity at surface
	velocity = velocity.bounce(collision.get_normal())

	# allows players to influence the balls velocity with their movement
	velocity += collision.get_collider_velocity()
	# if resulting velocity is slower than target_speed an extra repel velocity is added
	var curSpeedSqr = velocity.length_squared()
	if curSpeedSqr < target_speed ** 2:
		velocity = (velocity / sqrt(curSpeedSqr)) * target_speed # reset speed to target_speed
		_bounce_count = 0
	elif curSpeedSqr > target_speed ** 2:
		_slow_down_behaviour(sqrt(curSpeedSqr))

	# if collision is with player add repel force
	var other = collision.get_collider() as CollisionObject2D
	if other.get_collision_layer_value(_player_collision_layer_id):
		velocity += collision.get_normal() * repel_force
	
	# reflect remaining velocity at surface and return it for further movement
	return collision.get_remainder().bounce(collision.get_normal())


func _slow_down_behaviour(speed: float) -> void:
	if _bounce_count == damping_bounce_count:
		_bounce_count = 0
		velocity = (velocity / speed) * target_speed
		return

	var newSpeed = lerp(speed, target_speed, 1. / (damping_bounce_count - _bounce_count))
	_bounce_count += 1
	velocity = (velocity / speed) * newSpeed


func _find_player_collision_layer():
	for i in range(1, 33):
		if ProjectSettings.get_setting("layer_names/2d_physics/layer_" + str(i)) == "Player":
			_player_collision_layer_id = i
			break
	
	if _player_collision_layer_id == -1:
		printerr("Ball could not find collision layer with name 'Player'")
