extends Node
signal total_time_changed(new_total_seconds: int)

var total_seconds: int = 0
var _accum: float = 0.0
const SAVE_EVERY_SECONDS := 30
var _since_last_save := 0

const SAVE_PATH := "user://stats.cfg"
const SECTION := "playtime"
const KEY := "total_seconds"

func _ready() -> void:
	_load_from_disk()

func _process(delta: float) -> void:
	_accum += delta
	if _accum >= 1.0:
		var add := int(_accum)
		_accum -= add
		_add_seconds(add)

func _exit_tree() -> void:
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

# Utility per formattare carino
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
