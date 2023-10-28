extends CharacterBody2D

@export var speed: float

var sprite: AnimatedSprite2D
var detected: Array[CharacterBody2D] # array holding bodies in detection area

var CHASING = false

# on creation
func _ready():
	sprite = $MonsterSprite

# every frame
func _process(delta):
	#plays the bop (idle) animation
	sprite.play("bop")
	
	if CHASING == true:
		velocity = position.direction_to(detected[0].position)
		print(velocity)
						
		#choose sheep (player for now as it is the only thing there) closest
		#go towards them

# moves the monster with velocity
func _physics_process(delta):
	move_and_slide()

# detect when object enters detection area
func _on_area_body_entered(body):
	CHASING = true
	detected.append(body)

# detect when object leaves detection area
func _on_area_body_exited(body):
	detected.erase(body)
	velocity = Vector2(0,0)
	CHASING = false
