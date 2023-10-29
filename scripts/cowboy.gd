extends CharacterBody2D

@export var walk_speed = 100
@export var sprint_speed = 200
@export var move = true
var sprite: AnimatedSprite2D

signal sprint_used
signal gun_used
signal knockback_used

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

var _gun_ready = true
var _sprint_ready = true
var _knockback_ready = true

var _sprint = false

var _aimed_monster: CharacterBody2D

func _ready():
	$AimBar.scale = Vector2(0, 0.2)
	sprite = $CowboySprite
	$Gun.set_frame(2)
	$ZapArea/AOE.modulate.a = 0
	
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
		
func _start_sprint():
	sprint_used.emit()
	_sprint_ready = false
	$SprintTimer.start()
	
func aim_gun():
	if _aimed_monster != null:
		$Gun.look_at(_aimed_monster.position)
		if $Gun.rotation > PI/2 && $Gun.rotation > -PI/2:
			$Gun.scale = Vector2(-1,-1)
		else:
			$Gun.scale = Vector2(-1,1)
		
func set_current_aim_time_sprite():
	var percent_left = $AimTimer.get_time_left() / $AimTimer.get_wait_time()
	$AimBar.scale = Vector2(percent_left, 0.2)
	
func _fire_gun():
	gun_used.emit()
	_gun_ready = false
	_aimed_monster = SelectMonster.select_monster
	move = false
	
	$AimTimer.start(SkillSettings.gun_aim_time)
	$AimBar.scale = Vector2(1,0.2)
	$Gun.set_frame(0)
	var aim_bar_tween = get_tree().create_tween()
	#aim_bar_tween.tween_property($AimBar, "scale", Vector2(0, 0.2), SkillSettings.gun_aim_time)
	
	_aimed_monster.find_child("Target").show()
	

func _on_aim_timer_timeout():
	$Gun.play()
	move = true
	if _aimed_monster != null:
		_aimed_monster.queue_free()

func _use_zap():
	$ZapArea.scale = Vector2(SkillSettings.zap_range_multiplier, SkillSettings.zap_range_multiplier)
	#$AOE.scale = $ZapArea.scale * 2.35
	$ZapArea/AOE.modulate.a = 1
	get_tree().create_tween().tween_property($ZapArea/AOE, "modulate", Color.TRANSPARENT, 0.2)
	knockback_used.emit()
	_knockback_ready = false
	
	for body in $ZapArea.get_overlapping_bodies():
		if body.has_method("stun"):
			body.stun()
	
func _process(_delta):
	if Input.is_action_pressed("sprint") && _sprint_ready:
		_start_sprint()
	if Input.is_action_pressed("shoot") && _gun_ready && SelectMonster.select_monster != null:
		_fire_gun()
	if Input.is_action_pressed("zap") && _knockback_ready:
		_use_zap()
		
		
	aim_gun()
	set_current_aim_time_sprite()
	
	set_sprite()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * (walk_speed if $SprintTimer.is_stopped() else sprint_speed * SkillSettings.sprint_speed_multiplier)

func ready_sprint():
	_sprint_ready = true

func ready_gun():
	_gun_ready = true;
	print("Gun is ready to fire")

func ready_knockback():
	_knockback_ready = true

func _physics_process(delta):
	if move:
		get_input()
		move_and_slide()
