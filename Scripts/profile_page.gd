extends Control

@onready var back = $Button
@onready var userName = $VBoxContainer/HBoxContainer/VBoxContainer/LineEdit
@onready var avatar_button: Button = $VBoxContainer/HBoxContainer/Button
@onready var picker: Window = preload("res://Scenes/AvatarPicker.tscn").instantiate()
@onready var time_label: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Label2
@onready var grid: GridContainer = $VBoxContainer/MarginContainer/ScrollContainer/GridContainer
@onready var XP:= $VBoxContainer/HBoxContainer/VBoxContainer/XPBar
@export var return_to: int = 0
var _card_by_id: Dictionary = {}

func _ready() -> void:
	if not avatar_button.pressed.is_connected(_on_avatar_Button_pressed):
		avatar_button.pressed.connect(_on_avatar_Button_pressed)
	userName.text = GameManager.player_name
	userName.text_submitted.connect(_on_name_submitted)
	_connect_button(back, "_on_back_pressed")

	time_label.text = GameTime.format_time_hhmmss(GameTime.total_seconds)
	GameTime.total_time_changed.connect(_on_total_time_changed)

	# Avatar picker
	if not is_instance_valid(picker):
		picker = preload("res://Scenes/AvatarPicker.tscn").instantiate()
	if picker.get_parent() == null:
		get_tree().root.add_child(picker)
	picker.visible = false
	if picker.has_signal("avatar_selected") and not picker.avatar_selected.is_connected(_on_avatar_selected):
		picker.avatar_selected.connect(_on_avatar_selected)
	if picker.has_method("build_grid"):
		picker.build_grid()
	var full_tex = GameManager.get_avatar_texture_full()
	if full_tex:
		avatar_button.icon = full_tex
		avatar_button.text = ""

	# Niente load_state: persistenza gestita da AchievementsStore autoload
	_populate_achievements()

	if not Achievement.achievement_unlocked.is_connected(_on_achievement_unlocked):
		Achievement.achievement_unlocked.connect(_on_achievement_unlocked)

func _connect_button(btn: Button, pressed_callback_name: String) -> void:
	btn.pressed.connect(Callable(self, pressed_callback_name))
	

func _on_back_pressed():
	if return_to == 0:
		get_tree().change_scene_to_file("res:///Scenes/MainMenu.tscn")
	else:
		get_tree().change_scene_to_file("res:///Scenes/feed.tscn")

func _on_name_submitted(new_text: String):
	GameManager.set_player_name(new_text)
	
#non funziona
func _on_avatar_Button_pressed():
	if picker.has_method("build_grid"):
		picker.build_grid()
	picker.popup_centered()
	picker.move_to_foreground()

func _on_avatar_selected(id: String):
	GameManager.set_avatar(id)
	var full_tex = GameManager.get_avatar_texture_full()
	if full_tex:
		avatar_button.icon= full_tex
	picker.hide()
func _on_total_time_changed(new_total: int) -> void:
	time_label.text = GameTime.format_time_hhmmss(new_total)
	
func _populate_achievements() -> void:
	for child in grid.get_children():
		child.queue_free()
	_card_by_id.clear()

	var scene := preload("res://Scenes/AchievementCard.tscn")
	for id in Achievement.all():
		var data: Dictionary = Achievement.get_data(id)
		var unlocked: bool = Achievement.is_unlocked(id)

		var card := scene.instantiate() as AchievementCard
		grid.add_child(card)                      # 1) aggiungi prima
		card.setup_from_data(id, data, unlocked)  # 2) poi setup
		_card_by_id[id] = card

func _on_achievement_unlocked(id: String) -> void:
	if _card_by_id.has(id):
		var card: AchievementCard = _card_by_id[id]
		card.set_unlocked(true)
	else:
		# se la card non è presente, ricostruisci la griglia
		_populate_achievements()
