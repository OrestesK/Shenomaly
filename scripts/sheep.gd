extends CharacterBody2D

@onready var _sprite = $sheep_sprite

enum {FLEEING, ROAMING}
var current_state = ROAMING
var flee_from: Array[CharacterBody2D]

var MAX_SPEED = 20;
var random_target_pos : Vector2 = Vector2(0,0)
const CENTER = Vector2(0,0)

func _process(delta):
	#plays the bop (idle) animation
	_sprite.play("bop")
	
	match current_state:
		ROAMING:
			# THIS IS PROB NOT WORKING
			if position.distance_to(random_target_pos) <= MAX_SPEED * delta:
				random_target_pos = CENTER + Vector2(0,200).rotated(randf() * 2 * PI)
			else:
				position += position.direction_to(random_target_pos) * MAX_SPEED * delta
		FLEEING:
			for body in flee_from:
				#TODO MAKE ANOTHER FORMULA FOR THIS
				#determines strength of repulsion
				var strength = (1 / position.distance_to(body.position)) * 200
				#clamps streght
				strength = clampf(strength, 0, 2);
				#repulses
				position -= position.direction_to(body.position) * MAX_SPEED * delta * strength

#detect when object enters
func _on_detection_area_body_entered(body):
	current_state = FLEEING
	flee_from.append(body)


func _on_detection_area_body_exited(body):
	if flee_from.size() == 0:
		current_state = ROAMING
	print(flee_from.size())
	flee_from.erase(body)
	print(flee_from.size())
	
	random_target_pos = position
