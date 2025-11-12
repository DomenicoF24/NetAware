extends Node
signal achievement_unlocked(id: String)
# Catalogo statico
var _catalog: Dictionary = {
	"100PC": {
		"name": "PENSATORE CRITICO",
		"how": "Raggiungi il 100% di pensiero critico",
		"reward": "Avatar PENSIERO CRITICO",
		"icon": "res://images/ACHIEVEDSC100.png",
		"unlocked": false
	},
	"100E": {
		"name": "EMPATICO DIGITALE",
		"how": "Raggiungi il 100% di empatia",
		"reward": "100XP",
		"icon": "res://images/ACHIEVEDE100.png",
		"unlocked": false
	},
	"100P": {
		"name": "GUARDIANO DELLA PRIVACY",
		"how": "Raggiungi il 100% di privacy",
		"reward": "Avatar PRIVACY",
		"icon": "res://images/ACHIEVEDP100.png",
		"unlocked": false
	},
	"100D": {
		"name": "MAESTRO DEL BURNOUT",
		"how": "Raggiungi il 100% di dipendenza",
		"reward": "Avatar DIPENDENZA",
		"icon": "res://images/ACHIEVEDD100.png",
		"unlocked": false
	},
}

# Stato persistente: { id: bool }
var _unlocked: Dictionary = {}

func _ready() -> void:
	pass

func all() -> Array:
	# Ordinato per stabilità UI
	var ids := _catalog.keys()
	ids.sort()
	return ids

func get_data(id: String) -> Dictionary:
	var d: Dictionary = _catalog.get(id, {}).duplicate(true)
	if d.is_empty():
		return d
	d["unlocked"] = is_unlocked(id)
	return d

func get_catalog() -> Dictionary:
	var dup := _catalog.duplicate(true)
	AchievementsStore.merge_into(dup)
	return dup

func is_unlocked(id: String) -> bool:
	return AchievementsStore.is_unlocked(id)

func unlock(id: String) -> void:
	id = String(id).strip_edges()
	if not _catalog.has(id):
		push_warning("[Achievements] unlock(): id sconosciuto: '%s'" % id)
		return
	if AchievementsStore.is_unlocked(id):
		return
	AchievementsStore.mark_unlocked(id)
	emit_signal("achievement_unlocked", id)
	print("[Achievements] UNLOCKED: ", id)
