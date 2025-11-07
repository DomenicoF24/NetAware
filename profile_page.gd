extends Control

@onready var back = $Button
@onready var userName = $VBoxContainer/HBoxContainer/VBoxContainer/LineEdit

func _ready() -> void:
	userName.text = GameManager.player_name
	userName.text_submitted.connect(_on_name_submitted)
	_connect_button(back, "_on_back_pressed")

func _connect_button(btn: Button, pressed_callback_name: String) -> void:
	btn.pressed.connect(Callable(self, pressed_callback_name))
	

func _on_back_pressed() -> void:
	
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func _on_name_submitted(new_text: String):
	GameManager.set_player_name(new_text)
