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
		"unlocked": false
	},
	"100E": {
		"name": "EMPATICO DIGITALE",
		"how": "Raggiungi il 100% di empatia",
		"reward": "",
		"icon": "",
		"unlocked": false
	},
	"100P": {
		"name": "GUARDIANO DELLA PRIVACY",
		"how": "Raggiungi il 100% di privacy",
		"reward": "",
		"icon": "",
		"unlocked": false
	},
	"100D": {
		"name": "MAESTRO DELL'EQUILIBRIO",
		"how": "Raggiungi il 100% di dipendenza",
		"reward": "",
		"icon": "",
		"unlocked": false
	},
}

func ready() -> void:
	_load_from_disk()
	
func all() -> Array:
	return _catalog.keys()
	
func get_data(id: String) -> Dictionary:
	return _catalog.get(id,{})
	
func is_unlocked(id: String) -> bool:
	return bool(_catalog.get(id,{}).get("unlocked", false))
	
func unlock(id: String) -> void:
	if not _catalog.has(id):
		return
	if _catalog[id].get("unlocked", false):
		return
	_catalog[id]["unlocked"] = true
	_save_to_disk()
	emit_signal("achievement_unlocked", id)
	
func _save_to_disk() -> void:
	var cfg := ConfigFile.new()
	for id in _catalog.keys():
		cfg.set_value(SECTION, id, _catalog[id].get("unlocked", false))
	cfg.save(SAVE_PATH)

func _load_from_disk() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) == OK:
		for id in _catalog.keys():
			_catalog[id]["unlocked"] = bool(cfg.get_value(SECTION, id, false))
