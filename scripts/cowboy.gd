extends CharacterBody2D

@export var speed = 100
var sprite: AnimatedSprite2D


var current_dir = 0;


var error = PI/10
const EAST = 0
const SOUTH_EAST = PI / 4
const SOUTH = PI / 2
const SOUTH_WEST = 3 * PI / 4
const WEST = PI
const NORTH_WEST = -3 * PI / 4
const NORTH = -PI / 2
const NORTH_EAST = -PI / 4

func _ready():
	sprite = $CowboySprite
	
# Check if a is within error of b
func within(a, b, error):
	return (b - error < a && a < b + error)
	
func set_sprite():
	if velocity == Vector2(0, 0) : 
		if within(current_dir, NORTH_WEST, error) || within(current_dir, NORTH, error) || within(current_dir, NORTH_EAST, error):
			sprite.play("bop_back")
		else:
			sprite.play("bop_front")
		return
		
	current_dir = velocity.angle()
	
	if within(current_dir, EAST, error):
		sprite.set_flip_h( false )
		sprite.play("walk_front")
	elif within(current_dir, SOUTH_EAST, error):
		sprite.set_flip_h( false )
		sprite.play("walk_front")
	elif within(current_dir, SOUTH, error):
		sprite.play("walk_front")
	elif within(current_dir, SOUTH_WEST, error):
		sprite.set_flip_h( true )
		sprite.play("walk_front")
	elif within(current_dir, WEST, error):
		sprite.set_flip_h( true )
		sprite.play("walk_front")
	elif within(current_dir, NORTH_WEST, error):
		sprite.set_flip_h( true )
		sprite.play("walk_back")
	elif within(current_dir, NORTH, error):
		sprite.play("walk_back")
	elif within(current_dir, NORTH_EAST, error):
		sprite.set_flip_h( false )
		sprite.play("walk_back")
	else:
		pass
		
func _process(_delta):
	set_sprite()

	

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
