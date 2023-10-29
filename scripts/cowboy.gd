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

func _ready():
	sprite = $CowboySprite
	
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
	
func _fire_gun():
	gun_used.emit()
	_gun_ready = false
	SelectMonster.select_monster.queue_free()
	
func _use_zap():
	$ZapArea.scale = Vector2(SkillSettings.zap_range_multiplier, SkillSettings.zap_range_multiplier)
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
