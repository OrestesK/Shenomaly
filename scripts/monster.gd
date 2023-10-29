extends CharacterBody2D

@export var speed: float
@onready var monsterMoan =  $MonsterCollision/MonsterMoan

@export var stun_time = 2

var _sprite: AnimatedSprite2D
var _detected: Array[CharacterBody2D] # array holding bodies in detection area

var sheep: Array[CharacterBody2D]
var current_dir = 0;

var character 
var error = PI/10
const EAST = 0
const SOUTH_EAST = PI / 4
const SOUTH = PI / 2
const SOUTH_WEST = 3 * PI / 4
const WEST = PI
const NORTH_WEST = -3 * PI / 4
const NORTH = -PI / 2
const NORTH_EAST = -PI / 4

var stuck_time = 0.3

var _stunned = false

# on creation
func _ready():
	$Target.hide()
	_sprite = $MonsterSprite
	_sprite.play("bopFront")

# Check if a is within error of b
func within(a, b, error):
	return (b - error < a && a < b + error)
	
func set_sprite():
	if velocity == Vector2(0, 0) : 
		if within(current_dir, NORTH_WEST, error) || within(current_dir, NORTH, error) || within(current_dir, NORTH_EAST, error):
			_sprite.play("bopBack")
		else:
			_sprite.play("bopFront")
		return
		
	current_dir = velocity.angle()
	
	if within(current_dir, EAST, error):
		_sprite.set_flip_h( false )
		_sprite.play("walkFront")
	elif within(current_dir, SOUTH_EAST, error):
		_sprite.set_flip_h( false )
		_sprite.play("walkFront")
	elif within(current_dir, SOUTH, error):
		_sprite.play("walkFront")
	elif within(current_dir, SOUTH_WEST, error):
		_sprite.set_flip_h( true )
		_sprite.play("walkFront")
	elif within(current_dir, WEST, error):
		_sprite.set_flip_h( true )
		_sprite.play("walkFront")
	elif within(current_dir, NORTH_WEST, error):
		_sprite.set_flip_h( true )
		_sprite.play("walkBack")
	elif within(current_dir, NORTH, error):
		_sprite.play("walkBack")
	elif within(current_dir, NORTH_EAST, error):
		_sprite.set_flip_h( false )
		_sprite.play("walkBack")
	else:
		pass
		
# every frame
func _process(delta):
	if stuck_time > 0:
		stuck_time -= delta
		return
	#plays the bop (idle) animation
	set_sprite()
	
	if len(sheep) > 0:
		var closest := sheep[0]
		var smallest_dist := position.distance_to(sheep[0].position)
		for i in range(1, len(sheep)):
			var dist := position.distance_to(sheep[i].position)
			if dist < smallest_dist:
				closest = sheep[i]
				smallest_dist = dist
		velocity = position.direction_to(closest.position) * speed

	if _stunned:
		velocity = Vector2.ZERO
		
# moves the monster with velocity
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		if collision.get_collider().is_in_group("Sheep"):
			collision.get_collider().get_captured()
			monsterMoan.play()
			
func _on_mouse_entered():
	SelectMonster.select_monster = self

func _on_mouse_exited():
	if SelectMonster.select_monster == self:
		SelectMonster.select_monster = null
		
func stun():
	$StunTimer.start(stun_time * SkillSettings.stun_time_multiplier)
	_stunned = true

func _on_stun_timer_timeout():
	_stunned = false
