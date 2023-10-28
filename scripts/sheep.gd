extends CharacterBody2D

@export var roam_speed: float
@export var roam_acceleration: float
@export var fear_speed: float
@export var fear_acceleration: float
@export var max_turn_speed: float
@export var max_turn_accel: float
@export var max_avoidance: float

@onready var sheepbaah = $SheepBaaah

var _sprite: AnimatedSprite2D
var _detected: Array[CharacterBody2D] # array holding bodies in detection area

var _sheep_gone_callable: Callable

enum STATE {FLEEING, ROAMING}
var _current_state = STATE.ROAMING

var _turn_accel: float
var _turn_speed: float = 0
var _speed: float = roam_speed

func register_sheep_captured_callback(callback: Callable):
	_sheep_gone_callable = callback

func get_captured():
	_sheep_gone_callable.call(self)
	queue_free()

# on creation
func _ready():
	_sprite = $SheepSprite
	velocity = Vector2(0, 1).rotated(randf_range(0, 2 * PI)) * roam_speed
	_turn_accel = max_turn_accel if randf() > 0.5 else -max_turn_accel

func set_sprite():
	var angle = velocity.angle()
	if angle > -PI/2 and angle < PI/2:
		_sprite.set_flip_h( false )
	else:
		_sprite.set_flip_h( true )
		
	_sprite.play("bop")
# every frame
func _process(delta):
	# plays the bop (idle) animation
	set_sprite()
	
	_speed = clampf(_speed, roam_speed, fear_speed)
	
	match _current_state:
		STATE.ROAMING:
			if _speed > roam_speed:
				_speed -= roam_acceleration * delta
			
			# low chance of inverting turn_accel
			_turn_accel = -_turn_accel if randf() > 0.7 else _turn_accel
			# increases turn speed by a value
			_turn_speed += clampf(_turn_accel * delta, -max_turn_speed, max_turn_speed)
			# sets velocity
			velocity = velocity.rotated(_turn_speed * delta).normalized() * _speed
		STATE.FLEEING:
			if _speed < fear_speed:
				_speed += fear_acceleration * delta
			
			#calculate composite vector of all detected objects
			var fear_dir = Vector2.ZERO
			for body in _detected:
				fear_dir += body.position.direction_to(position)
			
			velocity = fear_dir.normalized() * _speed
	
# moves the sheep with velocity
func _physics_process(delta):
	move_and_slide()
	
	# obstacle avoidance
	$AvoidanceCaster.target_position = velocity
	var collider = $AvoidanceCaster.get_collider()
	if collider:
		var desired_dir = $AvoidanceCaster.get_collision_normal()
		var accel = (desired_dir * _speed - velocity)
		var magnitude = clampf(accel.length(), 0, max_avoidance * delta)
		accel = accel.normalized() * magnitude
		velocity += accel
	
# detect when object enters detection area
func _on_detection_area_body_entered(body):
	if body.is_in_group("FearSource"):
		_current_state = STATE.FLEEING
		_detected.append(body)
		sheepbaah.play()

# detect when object exits detection area
func _on_detection_area_body_exited(body):
	if body.is_in_group("FearSource"):
		_detected.erase(body)
		if _detected.size() == 0:
			_current_state = STATE.ROAMING
