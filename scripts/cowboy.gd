extends CharacterBody2D

@export var speed = 100
var sprite: AnimatedSprite2D

var half = PI/2

func _ready():
	sprite = $CowboySprite
	
func set_sprite():
	if velocity == Vector2(0, 0) : 
		sprite.play("bop_front")
		return
	
	var angle = velocity.angle()
	print(angle)
	
	if angle == 0:
		sprite.set_flip_h( false )
		sprite.play("walk_front")
	elif angle > half:
		sprite.set_flip_h( true )
		sprite.play("walk_front")
	elif angle < 0:
		sprite.play("walk_back")
	else:
		sprite.play("walk_front")
		
func _process(_delta):
	set_sprite()

	

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
