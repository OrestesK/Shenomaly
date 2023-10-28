extends Node2D

@export var cage_scene: PackedScene
@export var sheep_scene: PackedScene
#vector of min_x, min_y, max_x, max_y
@export var spawn_bounds: Vector4

var _cage: Node

func _ready():
	$CageTimer.start()

func on_cage_full():
	_cage.queue_free()
	$CageTimer.start()

func spawn_random_sheep():
	"""
	Randomly spawns a sheep using the spawn bounds
	"""
	var sheep = sheep_scene.instantiate()
	sheep.position = Vector2(randf_range(spawn_bounds.x, spawn_bounds.z), randf_range(spawn_bounds.y, spawn_bounds.w))
	add_child(sheep)

func spawn_new_cage():
	"""
	Randomly spawns a cage using the spawn bounds
	"""
	_cage = cage_scene.instantiate()
	_cage.position = Vector2(randf_range(spawn_bounds.x, spawn_bounds.z), randf_range(spawn_bounds.y, spawn_bounds.w))
	_cage.register_end_callback(on_cage_full)
	add_child(_cage)
