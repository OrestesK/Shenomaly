extends CanvasLayer

const STRIKES_FORMAT = "Strikes: %s"
const QUOATA_FORMAT = "Sheep remaining: %d"
const SKILLPOINT_FORMAT = "Skillpoint progress: (%d,%d)"
const COOLDOWN_FORMAT = "%s available in %ds"
const COOLDOWN_READY_FORMAT = "%s ready"

func set_strikes(count: int):
	$Info/Strikes.text = STRIKES_FORMAT % "X".repeat(count)

func set_quota_remaining(count: int):
	$Info/Quota.text = QUOATA_FORMAT % count

func set_gun_cooldown(time: float):
	if time > 0:
		$Info/GunCooldown.text = COOLDOWN_FORMAT % ["GUN", time]
	else:
		$Info/GunCooldown.text = COOLDOWN_READY_FORMAT % "GUN"
	
func set_knockback_cooldown(time: float):
	if time > 0:
		$Info/KnockbackCooldown.text = COOLDOWN_FORMAT % ["ZAP", time]
	else:
		$Info/KnockbackCooldown.text = COOLDOWN_READY_FORMAT % "ZAP"
	
func set_sprint_cooldown(time: float):
	if time > 0:
		$Info/SprintCooldown.text = COOLDOWN_FORMAT % ["SPRINT", time]
	else:
		$Info/SprintCooldown.text = COOLDOWN_READY_FORMAT % "SPRINT"

func set_skillpoint_progress(current: int, max: int):
	$Info/SkillpointProgress.text = SKILLPOINT_FORMAT % [current, max]
	
func hide_end_text():
	$Info/EndText.hide()
	
func show_end_text(text: String):
	$Info/EndText.text = text
	$Info/EndText.show()
