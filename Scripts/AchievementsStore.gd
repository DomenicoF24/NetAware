extends Node
const SAVE_PATH := "user://achievements.json"

var state: Dictionary = {} # { id: { "unlocked": bool, "unlocked_at": int } }

func _ready() -> void:
	load_state()

func load_state() -> void:
	state = {}
	if FileAccess.file_exists(SAVE_PATH):
		var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
		if f:
			var txt := f.get_as_text()
			var json := JSON.new()
			var err := json.parse(txt)
			if err == OK:
				var data = json.data
				if typeof(data) == TYPE_DICTIONARY:
					state = data

func save_state() -> void:
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(state))

func is_unlocked(id: String) -> bool:
	return bool((state.get(id, {}) as Dictionary).get("unlocked", false))

func mark_unlocked(id: String) -> void:
	if not state.has(id):
		state[id] = {}
	state[id]["unlocked"] = true
	state[id]["unlocked_at"] = Time.get_unix_time_from_system()
	save_state()

func merge_into(catalog: Dictionary) -> void:
	for id in catalog.keys():
		if is_unlocked(id):
			catalog[id]["unlocked"] = true

func reset_all() -> void:
	# 1) Svuota completamente lo stato in memoria
	state.clear()

	# 2) Elimina il file JSON dal disco
	if FileAccess.file_exists(SAVE_PATH):
		var da := DirAccess.open("user://")
		if da:
			var err := da.remove(SAVE_PATH)
			if err != OK:
				push_warning("Impossibile eliminare il file degli achievement: %s" % SAVE_PATH)
