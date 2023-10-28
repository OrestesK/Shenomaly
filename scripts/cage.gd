extends Area2D

@export var max_sheep = 10

var _current_sheep = 0
var _filled_callable: Callable
var _count_text: Label
var _time_text: Label

const COUNT_FORMAT = "%d/%d"
const TIME_FORMAT = "%ds"

func _ready():
	_count_text = get_node("Canvas/Sheep")
	_time_text = get_node("Canvas/RemainingTime")
	
	_count_text.text = COUNT_FORMAT % [_current_sheep, max_sheep]

func _process(delta):
	_time_text.text = TIME_FORMAT % $DespawnTimer.time_left

func _on_body_entered(body):
	# assume the only objects that can collide are sheeps
	if body.is_in_group("Sheep"):
		body.get_captured()
	_current_sheep += 1
	
	_count_text.text = COUNT_FORMAT % [_current_sheep, max_sheep]
	
	
	if _current_sheep == max_sheep:
		_end_cage()
	
func register_end_callback(callback: Callable):
	_filled_callable = callback

func _end_cage():
	_filled_callable.call(_current_sheep)
	queue_free()

func _on_despawn_timer_timeout():
	#cages have a timelimit
	_end_cage()
