extends CanvasLayer

signal perk_picked
signal main_menu
signal retry

const STRIKES_FORMAT = "Strikes: %s"
const QUOATA_FORMAT = "Sheep remaining: %d"
const SKILLPOINT_FORMAT = "Skillpoint progress: (%d/%d)"
const COOLDOWN_FORMAT = "%s available in %ds"
const COOLDOWN_READY_FORMAT = "%s ready"

func _ready():
	display_skills(false)

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
	$Info/EndScreen.hide()
	
func show_end_text(text: String):
	$Info/EndScreen/EndText.text = text
	$Info/EndScreen.show()
	
func set_perks(perks: Array[SkillSettings.PERKS]):
	$Info/Skills/Skill1/Text.text = SkillSettings.get_perk_detail(perks[0])
	$Info/Skills/Skill2/Text.text = SkillSettings.get_perk_detail(perks[1])
	$Info/Skills/Skill3/Text.text = SkillSettings.get_perk_detail(perks[2])
	
func display_skills(show: bool):
	if show:
		$Info/Skills.show()
	else:
		$Info/Skills.hide()

func _perk_button_pressed(index: int):
	perk_picked.emit(index)

func _on_main_menu_pressed():
	main_menu.emit()

func _on_retry_pressed():
	retry.emit()
