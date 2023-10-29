extends Node

var gun_cooldown = 30.0
var zap_cooldown = 10.0
var sprint_cooldown = 10.0
var gun_aim_time = 3.0
var stun_time_multiplier = 1.0
var zap_range_multiplier = 1.0
var sprint_speed_multiplier = 1.0

enum PERKS {GUN_CD, SPRINT_CD, ZAP_CD, AIM_T, STUN_MULT, ZAP_RANGE, SPRINT_SPEED}

# creates a list of 3 perks to pick from
func generate_perks():
	var options = []
	for i in range(3):
		options.append(PERKS.keys()[randi_range(0, len(PERKS.keys()) - 1)])
	return options
	
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
