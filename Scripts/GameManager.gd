extends Node

#Segnali
signal indicators_changed(sc, emp, priv, dep)
signal event_logged(text)
signal player_name_changed(new_name)
signal avatar_changed(tex_full: Texture2D, id: String)

#Valori iniziali
var spirito_critico := 50
var empatia := 50
var privacy := 50
var dipendenza := 0
var player_name: String = "Profilo"
var avatar_id: String = "default"

#Array di avatar
var avatars:= {
	"default": {"thumb": "res://images/profilo.png", "full": "res://images/profilo96.png", "unlocked": true},
	"girl1": {"thumb": "res://images/avatar/picGirl1-32.png", "full": "res://images//avatar96/picGirl1-96.png", "unlocked": true},
	"girl2": {"thumb": "res://images/avatar/picGirl2-32.png", "full": "res://images//avatar96/picGirl2-96.png", "unlocked": true},
	"girl3": {"thumb": "res://images/avatar/picGirl3-32.png", "full": "res://images//avatar96/picGirl3-96.png", "unlocked": true},
	"girl4": {"thumb": "res://images/avatar/picGirl4-32.png", "full": "res://images//avatar96/picGirl4-96.png", "unlocked": true},
	"girl5": {"thumb": "res://images/avatar/picGirl5-32.png", "full": "res://images//avatar96/picGirl5-96.png", "unlocked": true},
	"girl6": {"thumb": "res://images/avatar/picGirl6-32.png", "full": "res://images//avatar96/picGirl6-96.png", "unlocked": true},
	"girl7": {"thumb": "res://images/avatar/picGirl7-32.png", "full": "res://images//avatar96/picGirl7-96.png", "unlocked": true},
	"girl8": {"thumb": "res://images/avatar/picGirl8-32.png", "full": "res://images//avatar96/picGirl8-96.png", "unlocked": true},
	"girl9": {"thumb": "res://images/avatar/picGirl9-32.png", "full": "res://images//avatar96/picGirl9-96.png", "unlocked": true},
	"girl10": {"thumb": "res://images/avatar/picGirl10-32.png", "full": "res://images//avatar96/picGirl10-96.png", "unlocked": true},
	"girl11": {"thumb": "res://images/avatar/picGirl11-32.png", "full": "res://images//avatar96/picGirl11-96.png", "unlocked": true},
	"boy1": {"thumb": "res://images/avatar/picBoy1-32.png", "full": "res://images//avatar96/picBoy1-96.png", "unlocked": true},
	"boy2": {"thumb": "res://images/avatar/picBoy2-32.png", "full": "res://images//avatar96/picBoy2-96.png", "unlocked": true},
	"boy3": {"thumb": "res://images/avatar/picBoy3-32.png", "full": "res://images//avatar96/picBoy3-96.png", "unlocked": true},
	"boy4": {"thumb": "res://images/avatar/picBoy4-32.png", "full": "res://images//avatar96/picBoy4-96.png", "unlocked": true},
	"boy5": {"thumb": "res://images/avatar/picBoy5-32.png", "full": "res://images//avatar96/picBoy5-96.png", "unlocked": true},
	"boy6": {"thumb": "res://images/avatar/picBoy6-32.png", "full": "res://images//avatar96/picBoy6-96.png", "unlocked": true},
	"boy7": {"thumb": "res://images/avatar/picBoy7-32.png", "full": "res://images//avatar96/picBoy7-96.png", "unlocked": true},
	"SC100": {"thumb": "res://images/avatar/picSC100-32.png", "full": "res://images//avatar96/picSC100-96.png", "unlocked": false},
	"P100": {"thumb": "res://images/avatar/picP100-32.png", "full": "res://images//avatar96/picP100-96.png", "unlocked": false},
	"D100": {"thumb": "res://images/avatar/picD100-32.png", "full": "res://images//avatar96/picD100-96.png", "unlocked": false},
}

#suggerimenti educativi
var tips_by_category := {
	"fake_news": [
		"Verifica sempre la fonte originale.",
		"Attento ai titoli clickbait.",
		"Uno screenshot può essere manipolato.",
		"Controlla se la notizia è riportata anche da fonti affidabili.",
		"Non fermarti solo al titolo, leggi l’articolo completo.",
		"Le immagini possono essere manipolate: cerca la fonte originale.",
		"Diffida dalle notizie che fanno leva solo sulle emozioni.",
		"Verifica la data di pubblicazione: potrebbe essere una notizia vecchia riciclata."
	],
	"privacy_advice": [
		"Non condividere mai la tua password.",
		"Controlla le impostazioni della privacy.",
		"Non accettare richieste da sconosciuti.",
		"Non condividere informazioni personali con sconosciuti online.",
		"Usa password diverse per siti diversi.",
		"Attiva l’autenticazione a due fattori quando possibile.",
		"Controlla le impostazioni di privacy sui social network.",
		"Non pubblicare foto che rivelano la tua posizione in tempo reale."
	],
	"fraud": [
		"Diffida da offerte troppo belle per essere vere.",
		"Non cliccare su link sospetti o ricevuti via messaggi privati.",
		"Controlla sempre l’indirizzo del sito prima di inserire dati personali.",
		"Se ti chiedono denaro in anticipo, probabilmente è una truffa.",
		"Verifica che le email provengano davvero dall’ente ufficiale."
	],
	"default": [
		"Verifica sempre la fonte originale.",
		"Attento ai titoli clickbait.",
		"Uno screenshot può essere manipolato.",
		"Condividi solo ciò che leggeresti fino in fondo.",
		"Ricorda: il rispetto online vale quanto quello offline."
	]
}

var dep_timer: Timer  # timer per incremento automatico

func _ready() -> void:
	print("[GameManager] ready")
	emit_signal("indicators_changed", spirito_critico, empatia, privacy, dipendenza)
	load_profile()

# Timer automatico che aumenta la dipendenza ogni 10s
	dep_timer = Timer.new()
	dep_timer.wait_time = 8.0
	dep_timer.autostart = true
	dep_timer.one_shot = false
	add_child(dep_timer)
	dep_timer.timeout.connect(_on_dep_timer_timeout)


func _on_dep_timer_timeout() -> void:
	if dipendenza < 100:
		dipendenza = clamp(dipendenza + 1, 0, 100)
		emit_signal("indicators_changed", spirito_critico, empatia, privacy, dipendenza)

# Applica effetti agli indicatori. Esempio: {"sc": +5, "dep": -3}
func apply_effect(effect: Dictionary, reason: String = "") -> void:
	if effect.has("sc"):
		spirito_critico = clamp(spirito_critico + int(effect["sc"]), 0, 100)
	if effect.has("emp"):
		empatia = clamp(empatia + int(effect["emp"]), 0, 100)
	if effect.has("priv"):
		privacy = clamp(privacy + int(effect["priv"]), 0, 100)
	if effect.has("dep"):
		dipendenza = clamp(dipendenza + int(effect["dep"]), 0, 100)

	emit_signal("indicators_changed", spirito_critico, empatia, privacy, dipendenza)
	
	if reason != "":
		emit_signal("event_logged", reason)
	else:
		# Mostra un tip legato alla categoria
		emit_signal("event_logged", get_tip("category"))

	if spirito_critico >= 100 and not Achievement.is_unlocked("100PC"):
		_unlock_and_notify("100PC")
	if empatia >= 100 and not Achievement.is_unlocked("100E"):
		_unlock_and_notify("100E")
	if privacy >= 100 and not Achievement.is_unlocked("100P"):
		_unlock_and_notify("100P")
	if dipendenza >= 100 and not Achievement.is_unlocked("100D"):
		_unlock_and_notify("100D")

#DA FIXARE
#func _show_final_achievement(title: String, tex: Texture2D) -> void:
	#var popup = get_tree().root.get_node("Feed/AchievementPopup")
	#popup.show_achievement(title, tex)
	
	# Effetti visivi
	#var fireworks = get_tree().root.get_node("Feed/EffectsLayer/Fireworks")
	#fireworks.emitting = true
	# Aspetta la durata del popup + effetti
	#await get_tree().create_timer(5.0).timeout
	# Stop effetti
	#fireworks.emitting = false
	# Torna alla schermata principale
	# get_tree().change_scene("res://Scenes/MainMenu.tscn")



func _unlock_and_notify(id: String) -> void:
	Achievement.unlock(id)
	_notify_popup(id)

func _notify_popup(id: String) -> void:
	var data := Achievement.get_data(id)
	if data.is_empty():
		return
	var name := String(data.get("name", id))
	var icon_path := String(data.get("icon", ""))
	var tex: Texture2D = null
	if icon_path != "" and ResourceLoader.exists(icon_path):
		tex = load(icon_path)

	var popup := _get_achievement_popup()
	if popup == null:
		return
	if popup.has_method("show_achievement_id"):
		popup.show_achievement_id(id, name, tex)
	elif popup.has_method("show_achievement"):
		popup.show_achievement("Hai sbloccato: %s" % name, tex)

func _get_achievement_popup() -> Node:
	if has_node("AchievementPopup"):
		return $AchievementPopup
	var n := get_tree().root.get_node_or_null("Feed/AchievementPopup")
	if n: return n
	return get_tree().get_first_node_in_group("achievement_popup")

func _load_tex(path: String) -> Texture2D:
	return load(path) if path != "" and ResourceLoader.exists(path) else null
	
func get_avatar_texture_full(id := avatar_id) -> Texture2D:
	var info: Dictionary = avatars.get(id)
	if info:
		var tex: Texture2D = _load_tex(info.get("full", ""))
		if tex:
			return tex
		return _load_tex(info.get("thumb", ""))
	return null

func get_avatar_texture_thumb(id := avatar_id) -> Texture2D:
	var info: Dictionary = avatars.get(id)
	if info:
		var tex: Texture2D = _load_tex(info.get("thumb", ""))
		if tex:
			return tex
		return _load_tex(info.get("full", ""))
	return null

func set_avatar(id: String) -> void:
	if not avatars.has(id): return
	if not avatars[id].unlocked: return
	avatar_id = id
	save_profile()
	avatar_changed.emit(get_avatar_texture_full(), id)

func unlock_avatar(id: String) -> void:
	if avatars.has(id):
		avatars[id].unlocked = true
		save_profile()


func get_tip(category: String) -> String:
	if tips_by_category.has(category):
		var tips = tips_by_category[category]
		return tips[randi() % tips.size()]
	else:
		var tips = tips_by_category["default"]
		return tips[randi() % tips.size()]

func set_player_name(new_name: String):
	player_name = new_name
	save_profile()
	player_name_changed.emit(new_name)

#salva il profilo
func save_profile():
	var cfg := ConfigFile.new()
	cfg.set_value("profile", "name", player_name)
	cfg.set_value("profile", "avatar_id", avatar_id)
	var unlocked_ids := []
	for k in avatars.keys():
		if avatars[k].unlocked:
			unlocked_ids.append(k)
	cfg.set_value("profile", "unlocked_avatars", unlocked_ids)
	cfg.save("user://profile.cfg")
#carica il profilo
func load_profile():
	var cfg := ConfigFile.new()
	if cfg.load("user://profile.cfg") == OK:
		player_name = cfg.get_value("profile", "name", player_name)
		avatar_id = cfg.get_value("profile", "avatar_id", avatar_id)
		var unlocked_ids: Array =cfg.get_value("Profile", "unlocked_avatars", [])
		for k in avatars.keys():
			avatars[k].unlocked = k in unlocked_ids or avatars[k]. unlocked
