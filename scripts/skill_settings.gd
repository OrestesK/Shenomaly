extends Node

var gun_cooldown = 30.0
var zap_cooldown = 10.0
var sprint_cooldown = 10.0
var gun_aim_time = 3.0
var stun_time_multiplier = 1.0
var zap_range_multiplier = 1.0
var sprint_speed_multiplier = 1.0

@onready var _gun_cooldown = gun_cooldown
@onready var _zap_cooldown = zap_cooldown
@onready var _sprint_cooldown = sprint_cooldown
@onready var _gun_aim_time = gun_aim_time
@onready var _stun_time_multiplier = stun_time_multiplier
@onready var _zap_range_multiplier = zap_range_multiplier
@onready var _sprint_speed_multiplier = sprint_speed_multiplier

enum PERKS {GUN_CD, SPRINT_CD, ZAP_CD, AIM_T, STUN_MULT, ZAP_RANGE, SPRINT_SPEED}

# creates a list of 3 perks to pick from
func generate_perks():
	var options: Array[int] = []
	while len(options) != 3:
		var perk = PERKS.values()[randi_range(0, len(PERKS.values()) - 1)]
		if not perk in options:
			options.append(perk)
	return options

# applies a given perk
func apply_perk(perk: PERKS):
	match perk:
		PERKS.GUN_CD:
			gun_cooldown *= 0.85
		PERKS.SPRINT_CD:
			sprint_cooldown *= 0.85
		PERKS.ZAP_CD:
			zap_cooldown *= 0.85
		PERKS.AIM_T:
			gun_aim_time *= 0.90
		PERKS.STUN_MULT:
			stun_time_multiplier *= 1.1
		PERKS.ZAP_RANGE:
			zap_range_multiplier *= 1.1
		PERKS.SPRINT_SPEED:
			sprint_speed_multiplier *= 1.1

# gets a description of the given perk
func get_perk_detail(perk: PERKS):
	match perk:
		PERKS.GUN_CD:
			return "Reduce gun cooldown by 15%"
		PERKS.SPRINT_CD:
			return "Reduce sprint cooldown by 15%"
		PERKS.ZAP_CD:
			return "Reduce zap cooldown by 15%"
		PERKS.AIM_T:
			return "Reduce gun aim time by 10%"
		PERKS.STUN_MULT:
			return "Increase zap stun time by 10%"
		PERKS.ZAP_RANGE:
			return "Increaze zap range by 10%"
		PERKS.SPRINT_SPEED:
			return "Increase sprint speed by 10%"
			
func reset_perks():
	gun_cooldown = _gun_cooldown
	zap_cooldown = _zap_cooldown
	sprint_cooldown = _sprint_cooldown
	gun_aim_time = _gun_aim_time
	stun_time_multiplier = _stun_time_multiplier
	zap_range_multiplier = _zap_range_multiplier
	sprint_speed_multiplier = _sprint_speed_multiplier
