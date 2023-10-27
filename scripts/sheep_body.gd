extends CharacterBody2D

@onready var _sprite = $sheep_sprite

func _process(_delta):
	#plays the bop (idle) animation
	_sprite.play("bop")
