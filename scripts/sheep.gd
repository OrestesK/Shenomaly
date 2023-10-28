extends CharacterBody2D

@export var speed: float
@export var max_rotation: float
@export var max_turn_accel: float

var _sprite: AnimatedSprite2D
var _detected: Array[CharacterBody2D] # array holding bodies in detection area

var _sheep_gone_callable: Callable

enum STATE {FLEEING, ROAMING}
var _current_state = STATE.ROAMING

var _turn_accel: float
var _turn_speed: float = 0

func register_sheep_captured_callback(callback: Callable):
	_sheep_gone_callable = callback

func get_captured():
	_sheep_gone_callable.call(self)
	queue_free()

# on creation
func _ready():
	_sprite = $sheep_sprite
	velocity = Vector2(0, 1).rotated(randf() * 2 * PI) * speed
	_turn_accel = max_rotation if randf() > 0.5 else -max_rotation

# every frame
func _process(delta):
	# plays the bop (idle) animation
	_sprite.play("bop")
	
	match _current_state:
		STATE.ROAMING:
			# low chance of inverting turn_accel
			_turn_accel = -_turn_accel if randf() > 0.6 else _turn_accel
			# increases turn speed by a value
			_turn_speed += clampf(_turn_accel * delta, -max_rotation, max_rotation)
			# sets velocity
			velocity = velocity.rotated(_turn_speed * delta).normalized() * speed
			
		STATE.FLEEING:
				# for all bodies in area
				for body in _detected:
					# determines strength of repulsion
					var strength = (3 / position.distance_to(body.position)) * 100
					# repulses
					velocity = -position.direction_to(body.position) * speed * strength
	
# moves the sheep with velocity
func _physics_process(delta):
	move_and_slide()
	
# detect when object enters detection area
func _on_detection_area_body_entered(body):
	_current_state = STATE.FLEEING
	_detected.append(body)

# detect when object exits detection area
func _on_detection_area_body_exited(body):
	_detected.erase(body)
	if _detected.size() == 0:
		_current_state = STATE.ROAMING
