extends Node
signal total_time_changed(new_total_seconds: int)

var total_seconds: int = 0
var _accum: float = 0.0
const SAVE_EVERY_SECONDS := 30
var _since_last_save := 0

const SAVE_PATH := "user://stats.cfg"
const SECTION := "playtime"
const KEY := "total_seconds"

var _skip_save_on_exit: bool = false  # <-- AGGIUNGI QUESTO

func _ready() -> void:
	_load_from_disk()

func _process(delta: float) -> void:
	_accum += delta
	if _accum >= 1.0:
		var add := int(_accum)
		_accum -= add
		_add_seconds(add)

func _exit_tree() -> void:
	if _skip_save_on_exit:
		return            # <-- SE STO RESETTANDO, NON SALVO
	_save_to_disk()

func _add_seconds(n: int) -> void:
	if n <= 0:
		return
	total_seconds += n
	_since_last_save += n
	emit_signal("total_time_changed", total_seconds)
	if _since_last_save >= SAVE_EVERY_SECONDS:
		_save_to_disk()
		_since_last_save = 0

func _save_to_disk() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value(SECTION, KEY, total_seconds)
	cfg.save(SAVE_PATH)

func _load_from_disk() -> void:
	var cfg := ConfigFile.new()
	var err := cfg.load(SAVE_PATH)
	if err == OK:
		total_seconds = int(cfg.get_value(SECTION, KEY, 0))
	else:
		total_seconds = 0

# Utility per formattare carino (lascia tutto uguale)
static func format_time_hhmmss(seconds: int) -> String:
	var s : int = max(seconds, 0)
	var h : int = s / 3600
	var m : int = (s % 3600) / 60
	var sec : int = s % 60
	return "%02d:%02d:%02d" % [h, m, sec]

static func format_time_compact(seconds: int) -> String:
	var s : int = max(seconds, 0)
	var d : int = s / 86400
	var h : int = (s % 86400) / 3600
	var m : int = (s % 3600) / 60
	if d > 0:
		return "%dd %dh %dm" % [d, h, m]
	elif h > 0:
		return "%dh %dm" % [h, m]
	else:
		return "%dm" % [m]

func reset_time() -> void:
	# 1) Reset del tempo in memoria
	total_seconds = 0
	_accum = 0.0
	_since_last_save = 0

	# 2) Notifica eventuali UI che ascoltano il segnale
	emit_signal("total_time_changed", total_seconds)

	# 3) Non vogliamo che _exit_tree risalvi il tempo vecchio
	_skip_save_on_exit = true

	# 4) Elimina il file di salvataggio dal disco
	if FileAccess.file_exists(SAVE_PATH):
		var da := DirAccess.open("user://")
		if da:
			var file_name := SAVE_PATH.get_file() # "stats.cfg"
			var err := da.remove(file_name)
			if err != OK:
				push_warning("Impossibile eliminare il file di playtime: %s" % SAVE_PATH)
