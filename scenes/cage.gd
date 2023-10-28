extends Area2D

@export var max_sheep = 10

var _current_sheep = 0
var _filled_callable: Callable

func _on_body_entered(body):
	# assume the only objects that can collide are sheeps
	body.queue_free()
	_current_sheep += 1
	
	if _current_sheep == max_sheep:
		_filled_callable.call()
	
func register_end_callback(callback: Callable):
	_filled_callable = callback
