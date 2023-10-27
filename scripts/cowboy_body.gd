extends CharacterBody2D

@onready var _sprite = $cowboy_sprite
@export var speed = 100

func _process(_delta):
	#plays the bop (idle) animation
	_sprite.play("bop")

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	var collision = move_and_collide(velocity * delta)
	if collision:
		print("I collided with ", collision.get_collider().name)
