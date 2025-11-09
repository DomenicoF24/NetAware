extends Node
signal achievement_unlocked(id: String)

const SAVE_PATH := "user://achievements.cfg"
const SECTION := "achievements"

#Catalogo degli achievements
var _catalog: Dictionary = {
	"100PC": {
		"name": "PENSATORE CRITICO",
		"how": "Raggiungi il 100% di pensiero critico",
		"reward": "Avatar PENSIERO CRITICO",
		"icon": "res://images/AchieveSC100.png",
	},
	"100E": {
		"name": "EMPATICO DIGITALE",
		"how": "Raggiungi il 100% di empatia",
		"reward": "",
		"icon": "res://images/ACHIEVEE100.png",
	},
	"100P": {
		"name": "GUARDIANO DELLA PRIVACY",
		"how": "Raggiungi il 100% di privacy",
		"reward": "Avatar PRIVACY",
		"icon": "res://images/ACHIEVEP100.png",
	},
	"100D": {
		"name": "MAESTRO DELL'EQUILIBRIO",
		"how": "Raggiungi il 100% di dipendenza",
		"reward": "Avatar DIPENDENZA",
		"icon": "res://images/ACHIEVED100.png",
	},
}

var _unlocked : Dictionary = {}

func ready() -> void:
	_load_from_disk()
	for id in _catalog.keys():
		if not _unlocked.has(id):
			_unlocked[id] = false

func all() -> Array:
	return _catalog.keys()
	
func get_data(id: String) -> Dictionary:
	return _catalog.get(id,{})
	
func is_unlocked(id: String) -> bool:
	return bool(_catalog.get(id,{}).get(id, false))
	
func unlock(id: String) -> void:
	id = String(id).strip_edges()  # evita spazi accidentali
	if not _catalog.has(id):
		push_warning("[Achievements] unlock(): id sconosciuto: '%s'" % id)
		return
	if _unlocked.get(id, false):
		return
	_unlocked[id] = true
	_save_to_disk()
	emit_signal("achievement_unlocked", id)
	print("[Achievements] UNLOCKED: ", id)
	
func _save_to_disk() -> void:
	var cfg := ConfigFile.new()
	# Salviamo un dizionario {id: bool}
	cfg.set_value(SECTION, "state", _unlocked)
	var err := cfg.save(SAVE_PATH)
	if err != OK:
		push_warning("[Achievements] save error: %s" % err)

func _load_from_disk() -> void:
	_unlocked.clear()
	var cfg := ConfigFile.new()
	var err := cfg.load(SAVE_PATH)
	if err == OK:
		var loaded = cfg.get_value(SECTION, "state", null)
		if typeof(loaded) == TYPE_DICTIONARY:
			_unlocked = loaded
		else:
			# MIGRAZIONE: supporta vecchio formato (una chiave per riga)
			var rebuilt: Dictionary = {}
			for id in _catalog.keys():
				rebuilt[id] = bool(cfg.get_value(SECTION, id, false))
			_unlocked = rebuilt
	else:
		# Primo avvio: niente file -> restiamo col dict vuoto, inizializzato in _ready()
		pass

#salva all'uscita dal gioco
func _exit_tree() -> void:
	_save_to_disk()
