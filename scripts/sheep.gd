extends CharacterBody2D

@export var speed: float
@export var max_rotation: float
@export var max_turn_accel: float

var sprite: AnimatedSprite2D
var detected: Array[CharacterBody2D] # array holding bodies in detection area

enum STATE {FLEEING, ROAMING}
var current_state = STATE.ROAMING

var turn_accel: float
var turn_speed: float = 0

# on creation
func _ready():
	sprite = $sheep_sprite
	velocity = Vector2(0, 1).rotated(randf() * 2 * PI) * speed
	turn_accel = max_rotation if randf() > 0.5 else -max_rotation

# every frame
func _process(delta):
	# plays the bop (idle) animation
	sprite.play("bop")
	
	match current_state:
		STATE.ROAMING:
			# low chance of inverting turn_accel
			turn_accel = -turn_accel if randf() > 0.6 else turn_accel
			# increases turn speed by a value
			turn_speed += clampf(turn_accel * delta, -max_rotation, max_rotation)
			# sets velocity
			velocity = velocity.rotated(turn_speed * delta).normalized() * speed
			
		STATE.FLEEING:
				# for all bodies in area
				for body in detected:
					# determines strength of repulsion
					var strength = (3 / position.distance_to(body.position)) * 100
					# repulses
					velocity = -position.direction_to(body.position) * speed * strength
	
# moves the sheep with velocity
func _physics_process(delta):
	move_and_slide()
	
# detect when object enters detection area
func _on_detection_area_body_entered(body):
	current_state = STATE.FLEEING
	detected.append(body)

# detect when object exits detection area
func _on_detection_area_body_exited(body):
	detected.erase(body)
	if detected.size() == 0:
		current_state = STATE.ROAMING
