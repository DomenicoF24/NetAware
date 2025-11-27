# Scripts/SettingsWindow.gd
extends PopupPanel

@export var menu_checkbox_path: NodePath
@export var sound_checkbox_path: NodePath
@export var theme_option_path: NodePath
@export var reset_button_path: NodePath

var sound_checkbox: CheckBox
var theme_option: OptionButton
var reset_button: Button
var menu_checkbox: CheckBox
@onready var close := $MarginContainer/ButtonClose

func _ready() -> void:
	# Risolvi i nodi dalle path esportate
	if sound_checkbox_path != NodePath(""):
		sound_checkbox = get_node(sound_checkbox_path) as CheckBox
		
	if menu_checkbox_path != NodePath(""):
		menu_checkbox = get_node(menu_checkbox_path) as CheckBox

	if theme_option_path != NodePath(""):
		theme_option = get_node(theme_option_path) as OptionButton

	if reset_button_path != NodePath(""):
		reset_button = get_node(reset_button_path) as Button

	# Popola l'OptionButton tema
	if theme_option:
		theme_option.clear()
		theme_option.add_item("Chiaro", 0)
		theme_option.add_item("Scuro", 1)

	# Sincronizza stato iniziale con GameManager
	_sync_with_settings()

	# Collega segnali
	close.pressed.connect(_on_close_button_pressed)
	_connect_signals()


func _sync_with_settings() -> void:
	if sound_checkbox:
		var sound_on : bool = GameManager.get_setting("sound_on", true)
		sound_checkbox.button_pressed = sound_on
		
	if menu_checkbox:
		var menu_on : bool = GameManager.get_setting("menu_on", true)
		menu_checkbox.button_pressed = menu_on

	if theme_option:
		var theme : String = GameManager.get_setting("theme", "light")
		if theme == "dark":
			theme_option.select(1)
		else:
			theme_option.select(0)


func _connect_signals() -> void:
	if sound_checkbox and not sound_checkbox.toggled.is_connected(_on_sound_toggled):
		sound_checkbox.toggled.connect(_on_sound_toggled)
		
	if menu_checkbox and not menu_checkbox.toggled.is_connected(_on_menu_toggled):
		menu_checkbox.toggled.connect(_on_menu_toggled)

	if theme_option and not theme_option.item_selected.is_connected(_on_theme_item_selected):
		theme_option.item_selected.connect(_on_theme_item_selected)

	if reset_button and not reset_button.pressed.is_connected(_on_reset_button_pressed):
		reset_button.pressed.connect(_on_reset_button_pressed)


func _on_sound_toggled(pressed: bool) -> void:
	# Usa il metodo del GameManager che hai già creato
	GameManager.set_setting("sound_on", pressed)
	# In futuro collegherai qui il mute del bus audio

func _on_menu_toggled(pressed: bool) -> void:
	# Usa il metodo del GameManager che hai già creato
	GameManager.set_setting("menu_on", pressed)
	# In futuro collegherai qui il mute del bus audio
	
func _on_close_button_pressed() -> void:
	hide()


func _on_theme_item_selected(index: int) -> void:
	var id := theme_option.get_item_id(index)
	var theme := "light"
	if id == 1:
		theme = "dark"
	GameManager.set_setting("theme", theme)


func _on_reset_button_pressed() -> void:
	# Per ora placeholder, così non crasha
	# TODO: chiamare GameManager.reset_game_data() quando lo implementi
	pass
