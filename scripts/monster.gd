extends CharacterBody2D

@onready var _sprite = $MonsterSprite

var CHASING = false

var chase_this: Array[CharacterBody2D]
var speed = 25

func _process(delta):
	#plays the bop (idle) animation
	_sprite.play("bop")
	
	if CHASING == true:
		var player_direction = (chase_this[0].position - self.position).normalized()
		velocity = speed * player_direction
		move_and_slide()
						
		#choose sheep (player for now as it is the only thing there) closest
		#go towards them

func _on_area_body_entered(body):
	CHASING = true
	chase_this.append(body)
	print(body)


func _on_area_body_exited(body):
	chase_this.erase(body)
	velocity = speed * 0
	CHASING = false
