extends Node2D

@export var sheep_scene: PackedScene
#vector of min_x, min_y, max_x, max_y
@export var spawn_bounds: Vector4

func spawn_random_sheep():
	"""
	Randomly spawns a sheep using the spawn bounds
	"""
	var sheep = sheep_scene.instantiate()
	sheep.position = Vector2(randf_range(spawn_bounds.x, spawn_bounds.z), randf_range(spawn_bounds.y, spawn_bounds.w))
	add_child(sheep)
