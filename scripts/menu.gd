extends MarginContainer

const main_scene: PackedScene = preload("res://scenes/main.tscn")
var arrow1: Label
var arrow2: Label
var arrow3: Label
var current = 0

func _ready():
	arrow1 = $CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/Container1/HBoxContainer/Arrow1
	arrow2 = $CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/Container2/HBoxContainer/Arrow2
	arrow3 = $CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/Container3/HBoxContainer/Arrow3

func handle_selection():
	match current:
		0:
			get_tree().change_scene_to_packed(main_scene)
		1:
			pass
		2:
			pass
		
func select():
	arrow1.text = ""
	arrow2.text = ""
	arrow3.text = ""
	
	match current:
		0:
			arrow1.text = ">"
		1:
			arrow2.text = ">"
		2:
			arrow3.text = ">"

func _process(_delta):
	if Input.is_action_just_pressed("down"):
		current += 1
		if current == 3:
			current = 0
		select()
	elif Input.is_action_just_pressed("up"):
		current -= 1
		if current == -1:
			current = 2
		select()
	elif Input.is_action_just_pressed("accept"):
		handle_selection()
