extends Control

@onready var play_btn = $Center/MenuVbox/Play
@onready var btn_tutorial = $Center/MenuVbox/SmallButtons/Tutorial
@onready var btn_options = $Center/MenuVbox/SmallButtons/Impostazioni
@onready var btn_quit = $Center/MenuVbox/SmallButtons/Esci
@onready var btn_profile = $ProfileButton
@onready var gradient := ($Background.texture as GradientTexture2D).gradient
#@onready var click_sound = $UI_Audio

func _ready() -> void:
	
	# Connessioni
	_connect_button(play_btn, "_on_play_pressed")
	_connect_button(btn_quit, "_on_quit_pressed")
	_connect_button(btn_profile, "_on_profile_pressed")
	_connect_button(btn_tutorial, "_on_tutorial_button_pressed")
	_connect_button(btn_options, "_on_options_pressed")
	$ConfermaUscita.confirmed.connect(Callable(self, "_on_exit_confirmed"))
	
	_apply_theme(GameManager.get_setting("theme", "light"))

	if not GameManager.theme_changed.is_connected(_on_theme_changed):
		GameManager.theme_changed.connect(_on_theme_changed)
	
	btn_profile.text = GameManager.player_name
	if not GameManager.player_name_changed.is_connected(_on_player_name_changed):
		GameManager.player_name_changed.connect(_on_player_name_changed)
	
	_apply_avatar(GameManager.get_avatar_texture_thumb())
	if not GameManager.avatar_changed.is_connected(_on_avatar_changed):
		GameManager.avatar_changed.connect(_on_avatar_changed)
	# opzionale: riproduci musica di sottofondo se impostata
	# $BackgroundMusic.play()

# helper che connette pressed e mouse enter/exit per hover
func _connect_button(btn: Button, pressed_callback_name: String) -> void:
	btn.pressed.connect(Callable(self, pressed_callback_name))

# Pulsanti: comportamenti
func _on_play_pressed() -> void:
	#click_sound.play()
	# carica la scena del gioco (Feed o MainScene)
	get_tree().change_scene_to_file("res://Scenes/feed.tscn")

func _on_avatar_changed(tex: Texture2D, _id: String):
	_apply_avatar(tex)

func _apply_avatar(tex: Texture2D):
	if not tex: return
	if btn_profile is TextureRect:
		btn_profile.texture = tex
	elif btn_profile is Button:
		btn_profile.icon = tex
#func _on_tutorial_pressed() -> void:
#	click_sound.play()
#	# apri una scena tutorial o mostra popup
#	get_tree().change_scene_to_file("res://Scenes/Tutorial.tscn") # se hai creato

#func _on_options_pressed() -> void:
#	click_sound.play()
	# mostra menu opzioni
	# $OptionsPopup.popup_centered()

func _on_quit_pressed() -> void:
	#click_sound.play()
	$ConfermaUscita.popup_centered()

func _on_profile_pressed():
	var profile_scene = preload("res://Scenes/ProfilePage.tscn")
	var profile = profile_scene.instantiate()
	profile.return_to = 0

	var tree = get_tree()
	var old = tree.current_scene
	tree.root.add_child(profile)
	tree.current_scene = profile
	if old:
		old.queue_free()

func _on_tutorial_button_pressed() -> void:
	GameManager.force_feed_tutorial_once = true
	get_tree().change_scene_to_file("res://Scenes/feed.tscn")
	
func _on_options_pressed() -> void:
	var settings_scene := preload("res://Scenes/SettingsWindow.tscn").instantiate()
	add_child(settings_scene)
	settings_scene.popup_centered()

func _on_theme_changed(theme: String) -> void:
	_apply_theme(theme)

func _apply_theme(theme: String) -> void:
	if theme == "dark":
		# Tema scuro: stessi colori ma più profondi
		gradient.set_color(0, Color8(0x10, 0x10, 0x10)) # #101010
		gradient.set_color(1, Color8(0x18, 0x18, 0x18)) # #181818
		gradient.set_color(2, Color8(0x20, 0x20, 0x20)) # #202020
		gradient.set_color(3, Color8(0x28, 0x28, 0x28)) # #282828
	else:
		# Tema chiaro: i tuoi colori originali
		gradient.set_color(0, Color8(0xF5, 0x85, 0x29)) # f58529
		gradient.set_color(1, Color8(0xDD, 0x2A, 0x7B)) # dd2a7b
		gradient.set_color(2, Color8(0x81, 0x34, 0xAF)) # 8134af
		gradient.set_color(3, Color8(0x51, 0x5B, 0xD4)) # 515bd4


func _on_exit_confirmed():
	get_tree().quit()

func _on_player_name_changed(new_name: String):
	btn_profile.text = new_name
