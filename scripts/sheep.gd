extends CharacterBody2D

@onready var _sprite = $sheep_sprite

enum {FLEEING, ROAMING}
var current_state = ROAMING
var flee_from: Array[CharacterBody2D]

var MAX_SPEED = 30;
var random_target_pos : Vector2 = Vector2(0,0)
const CENTER = Vector2(0,0)

@export var max_rotation: float
@export var max_turn_accel: float

var turn_accel = 0
var turn_speed = 0

func _ready():
	velocity = Vector2(0, 1).rotated(randf() * 2 * PI) * MAX_SPEED
	turn_accel = max_rotation if randf() > 0.5 else -max_rotation

func _process(delta):
	#plays the bop (idle) animation
	_sprite.play("bop")
	
	match current_state:
		ROAMING:
			# low chance of inverting turn_accel
			turn_accel = -turn_accel if randf() > 0.6 else turn_accel
			# increases turn speed by a value
			turn_speed += clampf(turn_accel * delta, -max_rotation, max_rotation)
			# sets velocity
			velocity = velocity.rotated(turn_speed * delta).normalized() * MAX_SPEED

			# THIS IS PROB NOT WORKING
#			if position.distance_to(random_target_pos) <= MAX_SPEED * delta:
#				random_target_pos = CENTER + Vector2(0,200).rotated(randf() * 2 * PI)
#			else:
#				velocity = position.direction_to(random_target_pos) * MAX_SPEED
		FLEEING:
			for body in flee_from:
				#determines strength of repulsion
				var strength = (3 / position.distance_to(body.position)) * 100
				#clamps streght
				#strength = clampf(strength, 0, 2);
				#repulses
				velocity = -position.direction_to(body.position) * MAX_SPEED * strength

#moves the sheep with velocity
func _physics_process(delta):
	move_and_slide()
	
#detect when object enters
func _on_detection_area_body_entered(body):
	current_state = FLEEING
	flee_from.append(body)

#detect when object exits
func _on_detection_area_body_exited(body):
	flee_from.erase(body)
	if flee_from.size() == 0:
		current_state = ROAMING
	
	random_target_pos = position
