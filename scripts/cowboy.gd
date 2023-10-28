extends CharacterBody2D

@export var speed = 100

func _process(_delta):
	#plays the bop (idle) animation
	$CowboySprite.play("bop")
	

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()