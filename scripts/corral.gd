extends Node2D

@export_category("Overall Settings")
@export var max_sheep = 30
@export var sheep_quota = 10
@export var sp_per_perk = 3

@export_category("Random Settings")
#vector of min_x, min_y, max_x, max_y
@export var spawn_bounds: Vector4
@export var lightning_range: Vector2

@export_category("Scenes")
@export var cage_scene: PackedScene
@export var cage_falling_scene: PackedScene
@export var sheep_scene: PackedScene
@export var monster_scene: PackedScene
@onready var gamePlay = $Gameplay

var _cage: Node
var _cage_falling: Node
var _captured_sheep = 0
var _strikes = 2
var _sheep: Array[CharacterBody2D]
var _skillpoints = 0

const lightning_height = 800

var _perk_selection: Array[SkillSettings.PERKS]

func _ready():
	start_game()
	gamePlay.play()

func _process(delta):
	$HUD.set_gun_cooldown($GunCd.time_left)
	$HUD.set_knockback_cooldown($KnockbackCd.time_left)
	$HUD.set_sprint_cooldown($SprintCd.time_left)

func start_game():
	$SheepTimer.start()
	$CageTimer.start()
	$LightningTimer.start(randf_range(lightning_range.x, lightning_range.y))
	
	$HUD.set_strikes(_strikes)
	$HUD.set_quota_remaining(sheep_quota)
	$HUD.set_gun_cooldown(0.0)
	$HUD.set_knockback_cooldown(0.0)
	$HUD.set_sprint_cooldown(0.0)
	$HUD.set_skillpoint_progress(0, sp_per_perk)
	$HUD.hide_end_text()

func stop_game(won: bool):
	get_tree().call_group("Monster", "queue_free")
	get_tree().call_group("Sheep", "queue_free")
	
	$HUD.show_end_text("You win!" if won else "You're fired!")
	$SheepTimer.stop()
	$CageTimer.stop()
	$LightningTimer.stop()

func on_cage_done(count: int, give_strike: bool):
	#cage should despawn itself, just call the timer to spawn the next one
	_captured_sheep += count
	
	$HUD.set_quota_remaining(clamp(sheep_quota - _captured_sheep, 0, sheep_quota))
	
	if give_strike:
		_strikes -=1
		$HUD.set_strikes(_strikes)
	else:
		_skillpoints += 1
	
	if _strikes == 0:
		stop_game(false)
	elif _captured_sheep >= sheep_quota:
		stop_game(true)
	else:
		$CageTimer.start()
		
	# handle perks appearing
	if _skillpoints >= sp_per_perk:
		_display_perks()

func _display_perks():
	get_tree().paused = true
	_perk_selection = SkillSettings.generate_perks()
	$HUD.set_perks(_perk_selection)
	$HUD.display_skills(true)
	
func on_pick_perk(index: int):
	SkillSettings.apply_perk(_perk_selection[index])
	$HUD.display_skills(false)
	get_tree().paused = false

func on_sheep_removed(sheep: CharacterBody2D):
	_sheep.erase(sheep)

func spawn_random_sheep():
	"""
	Randomly spawns a sheep using the spawn bounds
	"""
	if len(_sheep) >= max_sheep:
		return
	var sheep = sheep_scene.instantiate()
	sheep.position = Vector2(randf_range(spawn_bounds.x, spawn_bounds.z), randf_range(spawn_bounds.y, spawn_bounds.w))
	sheep.register_sheep_captured_callback(on_sheep_removed)
	_sheep.append(sheep)
	add_child(sheep)

func spawn_new_cage():
	"""
	Randomly spawns a cage using the spawn bounds
	"""
	_cage_falling = cage_falling_scene.instantiate()
	#for n in 10000:
	#	cage_falling.position += Vector2(0, -11)
	#cage_falling.queue_free()
	
	_cage = cage_scene.instantiate()
	_cage.position = Vector2(randf_range(spawn_bounds.x, spawn_bounds.z), randf_range(spawn_bounds.y, spawn_bounds.w))
	_cage.register_end_callback(on_cage_done)
	add_child(_cage)

func on_lightning_strike():
	var sheep_index := 0
	var sheep := _sheep[sheep_index]
	while (sheep.position.y - 64/2 < -250):
		sheep_index = randi_range(0, len(_sheep) - 1)
		sheep = _sheep[sheep_index]
	
	$LightningStrike.play()
	$LightningStrike.position = sheep.position - Vector2(0, lightning_height / 2)
	
	_sheep.remove_at(sheep_index)
	sheep.process_mode = PROCESS_MODE_DISABLED
	var spawn_pos := sheep.position
	sheep.queue_free()
	
	$LightningEndTimer.start()
	
	
	$LightningTimer.start(randf_range(lightning_range.x, lightning_range.y))

func on_lightning_strike_end():
	var monster = monster_scene.instantiate()
	monster.sheep = _sheep
	monster.position = $LightningStrike.position + Vector2(0, lightning_height / 2 - 64/2)
	add_child(monster)

func _on_cowboy_gun_used():
	$GunCd.start(SkillSettings.gun_cooldown)

func _on_cowboy_knockback_used():
	$KnockbackCd.start(SkillSettings.zap_cooldown)

func _on_cowboy_sprint_used():
	$SprintCd.start(SkillSettings.sprint_cooldown)

func _on_knockback_cd_timeout():
	$Cowboy.ready_knockback()

func _on_gun_cd_timeout():
	$Cowboy.ready_gun()

func _on_sprint_cd_timeout():
	$Cowboy.ready_sprint()
