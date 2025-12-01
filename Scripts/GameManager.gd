extends Node

# Segnali
signal indicators_changed(sc, emp, priv, dep)
signal event_logged(text: String)
signal player_name_changed(new_name)
signal avatar_changed(tex_full: Texture2D, id: String)
signal xp_changed(current: int, max_value: int)
signal settings_changed()
signal theme_changed(theme: String)
signal feed_action_logged(entry: Dictionary)


# Valori iniziali
var spirito_critico := 50
var empatia := 50
var privacy := 50
var dipendenza := 0
var player_name: String = "Profilo"
var avatar_id: String = "default"
var xp: int = 0
var xp_max: int = 100
var has_seen_feed_tutorial: bool = false
var force_feed_tutorial_once: bool = false
const SETTINGS_PATH := "user://settings.cfg"
const PROFILE_SAVE_PATH := "user://profile.cfg"
var feed_session_log: Array[Dictionary] = []
var round_has_started: bool = false
var round_start_sc: int = 50
var round_start_emp: int = 50
var round_start_priv: int = 50
var round_start_dep: int = 0

var settings := {
	"sound_on": true,
	"theme": "light" # oppure "dark"
}

# Array di avatar
var avatars := {
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
	# Avatar sbloccabili con achievement:
	"100SC": {"thumb": "res://images/avatar/picSC100-32.png", "full": "res://images//avatar96/picSC100-96.png", "unlocked": false},
	"100P": {"thumb": "res://images/avatar/picP100-32.png", "full": "res://images//avatar96/picP100-96.png", "unlocked": false},
	"100D": {"thumb": "res://images/avatar/picD100-32.png", "full": "res://images//avatar96/picD100-96.png", "unlocked": false},
}

# suggerimenti educativi
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

var messages_catalog: Dictionary = {
	"msg1": {
		"sender_name": "Luca",
		"text": "Ehi, perché non pubblichi quella foto? Tanto non succede nulla.",
		"avatar_icon": "res://images/goal64.png",              # es. "res://images/avatar_luca.png"
		"category": "privacy_rischiosa"
	},
	"msg2": {
		"sender_name": "Anonimo",
		"text": "Questo tuo post fa davvero schifo...",
		"avatar_icon": "",
		"category": "hate_speech"
	},
	"msg3": {
		"sender_name": "Giulia",
		"text": "Ti va di confrontarti su quel commento che hai scritto?",
		"avatar_icon": "",
		"category": "confronto_costruttivo"
	}
}

func reset_messages_for_session() -> void:
	# Cancella lo stato dei messaggi della sessione precedente
	messages_state.clear()
	
func get_random_message_ids(count: int) -> Array[String]:
	var ids: Array[String] = []

	for key in messages_catalog.keys():
		# Usa SOLO i messaggi che non hanno ancora una entry in messages_state
		if not messages_state.has(key):
			ids.append(String(key))

	ids.shuffle()

	if count < ids.size():
		ids.resize(count)

	return ids

# Stato messaggi: "pending" (da gestire) / "handled" (già gestito)
var messages_state: Dictionary = {}   # { id: "pending"|"handled" }

signal message_added(id: String)
signal message_handled(id: String, action: String)

var dep_timer: Timer  # timer per incremento automatico

func _ready() -> void:
	print("[GameManager] ready")
	emit_signal("indicators_changed", spirito_critico, empatia, privacy, dipendenza)
	emit_signal("xp_changed", xp, xp_max)
	load_profile()
	load_settings()
	
	for id in messages_catalog.keys():
		if not messages_state.has(id):
			messages_state[id] = "handled"
	
	# Timer automatico che aumenta la dipendenza ogni 8s
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
		_check_indicator_achievements()

func reset_indicators_for_new_round() -> void:
	spirito_critico = 50
	empatia = 50
	privacy = 50
	dipendenza = 0

	emit_signal("indicators_changed", spirito_critico, empatia, privacy, dipendenza)

# Applica effetti agli indicatori. Esempio: {"sc": +5, "dep": -3}
func apply_effect(effect: Dictionary) -> void:
	if effect.has("sc"):
		spirito_critico = clamp(spirito_critico + int(effect["sc"]), 0, 100)
	if effect.has("emp"):
		empatia = clamp(empatia + int(effect["emp"]), 0, 100)
	if effect.has("priv"):
		privacy = clamp(privacy + int(effect["priv"]), 0, 100)
	if effect.has("dep"):
		dipendenza = clamp(dipendenza + int(effect["dep"]), 0, 100)

	emit_signal("indicators_changed", spirito_critico, empatia, privacy, dipendenza)
	
	var cat: String = effect.get("category", "default")
	emit_signal("event_logged", get_tip(cat))

	_check_indicator_achievements()

func _check_indicator_achievements() -> void:
	if spirito_critico >= 100 and not Achievement.is_unlocked("100SC"):
		_unlock_and_notify("100SC")
	if empatia >= 100 and not Achievement.is_unlocked("100E"):
		_unlock_and_notify("100E")
	if privacy >= 100 and not Achievement.is_unlocked("100P"):
		_unlock_and_notify("100P")
	if dipendenza >= 100 and not Achievement.is_unlocked("100D"):
		_unlock_and_notify("100D")

func _unlock_and_notify(id: String) -> void:
	Achievement.unlock(id)
	_apply_achievement_reward(id)
	save_profile()
	_notify_popup(id)

func _apply_achievement_reward(id: String) -> void:
	# Mappa achievement -> reward
	match id:
		"100SC":
			# Sblocca avatar pensiero critico
			unlock_avatar("100SC")
		"100E":
			# Aggiungi XP (puoi cambiare il valore)
			add_xp(10)
		"100P":
			unlock_avatar("100P")
		"100D":
			unlock_avatar("100D")
		_:
			pass

func add_xp(amount: int) -> void:
	xp = clamp(xp + amount, 0, xp_max)
	emit_signal("xp_changed", xp, xp_max)
	
func log_feed_action(post_label: String, action: String, effect: Dictionary, category: String = "") -> void:
	var deltas: Dictionary = {}

	if effect.has("sc"):
		var sc_delta := int(effect["sc"])
		if sc_delta != 0:
			deltas["SC"] = sc_delta
	if effect.has("emp"):
		var emp_delta := int(effect["emp"])
		if emp_delta != 0:
			deltas["EM"] = emp_delta
	if effect.has("priv"):
		var priv_delta := int(effect["priv"])
		if priv_delta != 0:
			deltas["PR"] = priv_delta
	if effect.has("dep"):
		var dep_delta := int(effect["dep"])
		if dep_delta != 0:
			deltas["DP"] = dep_delta

	var sum := 0
	for v in deltas.values():
		sum += int(v)

	var result := "Neutro"
	if sum > 0:
		result = "Corretto"
	elif sum < 0:
		result = "Errore"

	var entry := {
		"post_label": post_label,
		"action": action,
		"result": result,
		"deltas": deltas,
		"category": category
	}

	feed_session_log.append(entry)
	feed_action_logged.emit(entry)

func begin_round(reset_stats: bool) -> void:
	if reset_stats:
		reset_indicators_for_new_round()  # usa la funzione che hai già

	round_start_sc = spirito_critico
	round_start_emp = empatia
	round_start_priv = privacy
	round_start_dep = dipendenza
	round_has_started = true

func get_setting(key: String, default_value = null):
	if settings.has(key):
		return settings[key]
	return default_value

func set_setting(key: String, value) -> void:
	settings[key] = value
	_save_settings()
	if key == "theme":
		theme_changed.emit(value)
	settings_changed.emit()
	
func load_settings() -> void:
	var cfg := ConfigFile.new()
	var err := cfg.load(SETTINGS_PATH)
	if err != OK:
		return

	for key in settings.keys():
		if cfg.has_section_key("settings", key):
			settings[key] = cfg.get_value("settings", key, settings[key])

	# Applica subito i valori (es. tema o suono)
	_apply_settings_on_startup()


func _save_settings() -> void:
	var cfg := ConfigFile.new()
	for key in settings.keys():
		cfg.set_value("settings", key, settings[key])
	cfg.save(SETTINGS_PATH)


func _apply_settings_on_startup() -> void:
	# Tema
	theme_changed.emit(settings["theme"])
	# Suono
	#_apply_sound_state()
	
#func toggle_sound(on: bool) -> void:
	#set_setting("sound_on", on)
	#_apply_sound_state()


#func _apply_sound_state() -> void:
	#var on := settings["sound_on"]

	# Se usi i bus audio di Godot:
	# var idx = AudioServer.get_bus_index("Master")
	# AudioServer.set_bus_mute(idx, not on)

# ----------------- POPUP ACHIEVEMENT -----------------

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
	if n:
		return n
	return get_tree().get_first_node_in_group("achievement_popup")

func _load_tex(path: String) -> Texture2D:
	return load(path) if path != "" and ResourceLoader.exists(path) else null

# ----------------- AVATAR -----------------

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
	if not avatars.has(id):
		return
	var info: Dictionary = avatars[id]
	if not info.get("unlocked", false):
		return
	avatar_id = id
	save_profile()
	avatar_changed.emit(get_avatar_texture_full(), id)

func unlock_avatar(id: String) -> void:
	if not avatars.has(id):
		return
	var info: Dictionary = avatars[id]
	if info.get("unlocked", false):
		return
	info["unlocked"] = true
	avatars[id] = info
	save_profile()

# ----------------- ALTRI METODI -----------------

func get_tip(category: String = "default") -> String:
	var list: Array = tips_by_category.get(category, tips_by_category["default"])
	return list[randi() % list.size()]

func set_player_name(new_name: String) -> void:
	player_name = new_name
	save_profile()
	player_name_changed.emit(new_name)

# salva il profilo
func save_profile() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("profile", "name", player_name)
	cfg.set_value("profile", "avatar_id", avatar_id)
	cfg.set_value("profile", "xp", xp)

	var unlocked_ids: Array = []
	for k in avatars.keys():
		var info: Dictionary = avatars[k]
		if info.get("unlocked", false):
			unlocked_ids.append(k)
	cfg.set_value("profile", "unlocked_avatars", unlocked_ids)
	
	cfg.set_value("profile", "has_seen_feed_tutorial", has_seen_feed_tutorial)

	cfg.save("user://profile.cfg")

# carica il profilo
func load_profile() -> void:
	var cfg := ConfigFile.new()
	if cfg.load("user://profile.cfg") == OK:
		player_name = cfg.get_value("profile", "name", player_name)
		avatar_id = cfg.get_value("profile", "avatar_id", avatar_id)
		xp = int(cfg.get_value("profile", "xp", xp))

		var unlocked_ids: Array = cfg.get_value("profile", "unlocked_avatars", [])
		for k in avatars.keys():
			var info: Dictionary = avatars[k]
			info["unlocked"] = k in unlocked_ids or info.get("unlocked", false)
			avatars[k] = info
			
		has_seen_feed_tutorial = bool(cfg.get_value("profile", "has_seen_feed_tutorial", false))

		emit_signal("xp_changed", xp, xp_max)
		emit_signal("indicators_changed", spirito_critico, empatia, privacy, dipendenza)

func wipe_all_save_files() -> void:
	var da := DirAccess.open("user://")
	if da == null:
		push_warning("Impossibile aprire la cartella user:// per il reset dei dati.")
		return

	# Reset achiev e tempo (loro si cancellano il file da soli)
	AchievementsStore.reset_all()
	GameTime.reset_time()

	# Cancella solo il profilo qui
	if FileAccess.file_exists(PROFILE_SAVE_PATH):
		var file_name : String = PROFILE_SAVE_PATH.get_file()
		var err := da.remove(file_name)
		if err != OK:
			push_warning("Impossibile eliminare il file: %s" % PROFILE_SAVE_PATH)

	get_tree().quit()

func reset_feed_session_log() -> void:
	feed_session_log.clear()

func get_message_data(id: String) -> Dictionary:
	return messages_catalog.get(id, {}) as Dictionary

func get_pending_messages() -> Array[String]:
	var res: Array[String] = []
	for id in messages_catalog.keys():
		if messages_state.get(id, "handled") == "pending":
			res.append(id as String)
	return res

func add_message(id: String) -> void:
	if not messages_catalog.has(id):
		push_warning("add_message: id sconosciuto '%s'" % id)
		return

	# Se è già pending in questa sessione, non lo ri-aggiungo
	if messages_state.get(id, "none") == "pending":
		return

	messages_state[id] = "pending"
	emit_signal("message_added", id)

func handle_message(id: String, action: String) -> void:
	if not messages_catalog.has(id):
		return
	messages_state[id] = "handled"
	emit_signal("message_handled", id, action)
	_apply_message_effect(id, action)

func _apply_message_effect(id: String, action: String) -> void:
	var data: Dictionary = messages_catalog.get(id, {}) as Dictionary
	var category: String = String(data.get("category", ""))

	var effect: Dictionary = {}  # { "sc": int, "emp": int, "priv": int, "dep": int }

	match category:
		"privacy_rischiosa":
			match action:
				"segnala":
					effect = {"sc": 10, "priv": 10}
				"ignora":
					effect = {"sc": -5, "priv": -10}
				"rispondi":
					effect = {"emp": 5, "priv": -5}
		"hate_speech":
			match action:
				"segnala":
					effect = {"sc": 10, "emp": 5}
				"ignora":
					effect = {"emp": -5}
				"rispondi":
					effect = {"emp": 10}
		"confronto_costruttivo":
			match action:
				"rispondi":
					effect = {"emp": 10, "sc": 5}
				"ignora":
					effect = {"emp": -5}
		_:
			# Categoria sconosciuta: niente effetto, solo debug
			print("Messaggio senza categoria gestita:", id, "azione:", action, "categoria:", category)

	# Etichetta per il blocco note
	var sender_name := String(data.get("sender_name", "Utente"))
	var label := "Msg: %s" % sender_name

	# Nome azione "pulito" per il log
	var pretty_action := ""
	match action:
		"ignora":
			pretty_action = "Ignora"
		"rispondi":
			pretty_action = "Rispondi"
		"segnala":
			pretty_action = "Segnala"
		_:
			pretty_action = action.capitalize()

	# Logga SEMPRE l'azione (anche se effect è vuoto → Neutro)
	log_feed_action(label, pretty_action, effect, category)

	# Applica l'effetto solo se c'è qualcosa da applicare
	if not effect.is_empty():
		apply_effect(effect)
