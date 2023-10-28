extends CanvasLayer

const STRIKES_FORMAT = "Strikes: %s"
const QUOATA_FORMAT = "Sheep remaining: %d"
const SKILLPOINT_FORMAT = "Skillpoint progress: (%d,%d)"
const COOLDOWN_FORMAT = "%s available in %ds"
const COOLDOWN_READY_FORMAT = "%s ready"

func set_strikes(count: int):
	$Info/TopLeft/Strikes.text = STRIKES_FORMAT % "X".repeat(count)

func set_quota_remaining(count: int):
	$Info/TopRight/Quota.text = QUOATA_FORMAT % count

func set_gun_cooldown(time: float):
	if time > 0:
		$Info/BottomLeft/GunCooldown.text = COOLDOWN_FORMAT % ["GUN", time]
	else:
		$Info/BottomLeft/GunCooldown.text = COOLDOWN_READY_FORMAT % "GUN"
	
func set_knockback_cooldown(time: float):
	if time > 0:
		$Info/BottomLeft/KnockbackCooldown.text = COOLDOWN_FORMAT % ["ZAP", time]
	else:
		$Info/BottomLeft/KnockbackCooldown.text = COOLDOWN_READY_FORMAT % "ZAP"
	
func set_sprint_cooldown(time: float):
	if time > 0:
		$Info/BottomLeft/SprintCooldown.text = COOLDOWN_FORMAT % ["SPRINT", time]
	else:
		$Info/BottomLeft/SprintCooldown.text = COOLDOWN_READY_FORMAT % "SPRINT"

func set_skillpoint_progress(current: int, max: int):
	$Info/TopLeft/SkillpointProgress.text = SKILLPOINT_FORMAT % [current, max]
	
func hide_end_text():
	$Info/Center/EndText.hide()
	
func show_end_text(text: String):
	$Info/Center/EndText.text = text
	$Info/Center/EndText.show()
