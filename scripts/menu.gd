extends Control

const main_scene: PackedScene = preload("res://scenes/main.tscn")
var current = 0
@onready var titleScreen = $TitleScreen

func _ready():
	titleScreen.play()

func start_game():
	get_tree().change_scene_to_packed(main_scene)

func display_settings():
	$Settings.show()

func exit_settings():
	$Settings.hide()
