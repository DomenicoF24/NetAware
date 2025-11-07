extends Control

@onready var play_btn = $Center/MenuVbox/Play
@onready var btn_tutorial = $Center/MenuVBox/SmallButtons/Tutorial
@onready var btn_objectives = $Center/MenuVBox/SmallButtons/Obiettivi
@onready var btn_options = $Center/MenuVBox/SmallButtons/Impostazioni
@onready var btn_quit = $Center/MenuVbox/SmallButtons/Esci
@onready var btn_profile = $ProfileButton
#@onready var click_sound = $UI_Audio

func _ready() -> void:
	# Focus iniziale sul Play
	play_btn.grab_focus()
	
	# Connessioni
	_connect_button(play_btn, "_on_play_pressed")
	_connect_button(btn_quit, "_on_quit_pressed")
	_connect_button(btn_profile, "_on_profile_pressed")
	$ConfermaUscita.confirmed.connect(Callable(self, "_on_exit_confirmed"))
	#_connect_button(btn_tutorial, "_on_tutorial_pressed")
	#_connect_button(btn_objectives, "_on_objectives_pressed")
	#_connect_button(btn_options, "_on_options_pressed")
	btn_profile.text = GameManager.player_name
	if not GameManager.player_name_changed.is_connected(_on_player_name_changed):
		GameManager.player_name_changed.connect(_on_player_name_changed)
	
	
	# opzionale: riproduci musica di sottofondo se impostata
	# $BackgroundMusic.play()

# helper che connette pressed e mouse enter/exit per hover
func _connect_button(btn: Button, pressed_callback_name: String) -> void:
	btn.pressed.connect(Callable(self, pressed_callback_name))

# Pulsanti: comportamenti
func _on_play_pressed() -> void:
	#click_sound.play()
	# carica la scena del gioco (Feed o MainScene)
	get_tree().change_scene_to_file("res://feed.tscn")

#func _on_tutorial_pressed() -> void:
#	click_sound.play()
#	# apri una scena tutorial o mostra popup
#	get_tree().change_scene_to_file("res://Scenes/Tutorial.tscn") # se hai creato

#func _on_objectives_pressed() -> void:
#	click_sound.play()
	# mostra popup con obiettivi (o change_scene)
	# Example: mostra un ConfirmationDialog o Popup con testo
	# $ObjectivesPopup.show()

#func _on_options_pressed() -> void:
#	click_sound.play()
	# mostra menu opzioni
	# $OptionsPopup.popup_centered()

func _on_quit_pressed() -> void:
	#click_sound.play()
	$ConfermaUscita.popup_centered()

func _on_profile_pressed() -> void:
	#click_sound.play()
	# carica la scena del gioco (Feed o MainScene)
	get_tree().change_scene_to_file("res://ProfilePage.tscn")

func _on_exit_confirmed():
	get_tree().quit()

func _on_player_name_changed(new_name: String):
	btn_profile.text = new_name
