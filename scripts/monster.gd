extends CharacterBody2D

@export var speed: float

var _sprite: AnimatedSprite2D
var _detected: Array[CharacterBody2D] # array holding bodies in detection area

var sheep: Array[CharacterBody2D]

# on creation
func _ready():
	_sprite = $MonsterSprite

# every frame
func _process(delta):
	#plays the bop (idle) animation
	_sprite.play("bop")
	
	if len(sheep) > 0:
		var closest := sheep[0]
		var smallest_dist := position.distance_to(sheep[0].position)
		for i in range(1, len(sheep)):
			var dist := position.distance_to(sheep[i].position)
			if dist < smallest_dist:
				closest = sheep[i]
				smallest_dist = dist
		velocity = position.direction_to(closest.position) * speed

# moves the monster with velocity
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		if collision.get_collider().has_method("get_captured"):
			collision.get_collider().get_captured()
	

