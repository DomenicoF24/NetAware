extends Control

@onready var back = $Button
@onready var userName = $VBoxContainer/HBoxContainer/VBoxContainer/LineEdit
@onready var avatar_button:= $VBoxContainer/HBoxContainer/TextureButton
@onready var picker:= preload("res://AvatarPicker.tscn").instantiate()

func _ready() -> void:
	userName.text = GameManager.player_name
	userName.text_submitted.connect(_on_name_submitted)
	_connect_button(back, "_on_back_pressed")
	
	add_child(picker)
	picker.hide()
	picker.avatar_selected.connect(_on_avatar_selected)
	var full_tex = GameManager.get_avatar_texture_full()
	if full_tex: avatar_button.texture_normal = full_tex

func _connect_button(btn: Button, pressed_callback_name: String) -> void:
	btn.pressed.connect(Callable(self, pressed_callback_name))
	

func _on_back_pressed() -> void:
	
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func _on_name_submitted(new_text: String):
	GameManager.set_player_name(new_text)
	
func _on_avatar_TextureButton_pressed():
	picker.popup_centered_ratio(0.6)

func _on_avatar_selected(id: String):
	GameManager.set_avatar(id)
	var full_tex = GameManager.get_avatar_texture_full()
	if full_tex:
		avatar_button.texture_normal = full_tex
