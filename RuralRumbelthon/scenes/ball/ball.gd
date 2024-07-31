extends AnimatableBody2D
class_name Ball

@export var speed = 400.0
@export var damping = 80.0

var velocity: Vector2

func _ready():
	# we manually move the ball using PhysicsBody2D.move_and_collide()
	sync_to_physics = false
	
	# velocity between -45 degree and 45
	velocity = Vector2.from_angle(-PI / 4 + randf() * PI / 2) * speed

func _physics_process(delta):
	
	var collision = move_and_collide(velocity * delta) as KinematicCollision2D
	# collide up to 10 bounces
	for i in 10:
		if not collision:
			break
		
		if collision.get_collider().has_method("_on_ball_hit"):
			collision.get_collider().call("_on_ball_hit", self)
			
		var bounce = collision.get_remainder().bounce(collision.get_normal())
		velocity = velocity.bounce(collision.get_normal()) + collision.get_collider_velocity()
		collision = move_and_collide(bounce)
	
	
	var curSpeedSqr = velocity.length_squared()
	if abs(curSpeedSqr - speed ** 2) > 0.01:
		var curSpeed = sqrt(curSpeedSqr)
		velocity /= curSpeed # normalizes velocity
		curSpeed = move_toward(curSpeed, speed, damping * delta)
		velocity *= curSpeed
