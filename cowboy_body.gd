extends CharacterBody2D

@onready var _sprite = $cowboy_sprite

func _process(_delta):
		_sprite.play("bop")
