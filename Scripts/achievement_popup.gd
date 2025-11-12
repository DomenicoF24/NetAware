extends PopupPanel

@onready var label: Label = $Label
@onready var icon: TextureRect = $TextureRect

var _shown := {}        # id -> true
var _queue: Array[Dictionary] = []  # [{id, title, icon}]
var _showing := false

# fallback icona medaglia, se manca l'icona dell'achievement
var _fallback_medal: Texture2D = preload("res://images/medal.png") # usa il percorso che avevi prima

func _ready() -> void:
	# Stile: pannello bianco semi-trasparente con angoli arrotondati e ombra
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(1, 1, 1, 0.9) # bianco con alpha
	sb.corner_radius_top_left = 16
	sb.corner_radius_top_right = 16
	sb.corner_radius_bottom_left = 16
	sb.corner_radius_bottom_right = 16
	sb.shadow_size = 12
	sb.shadow_color = Color(0, 0, 0, 0.25)
	add_theme_stylebox_override("panel", sb)

	# opzionale: padding interno
	sb.content_margin_left = 16
	sb.content_margin_right = 16
	sb.content_margin_top = 12
	sb.content_margin_bottom = 12

	# assicura che il nodo sia nel gruppo per essere trovato dal codice
	if not is_in_group("achievement_popup"):
		add_to_group("achievement_popup")

func show_achievement_id(id: String, title: String, icon_tex: Texture2D) -> void:
	if _shown.has(id):
		return
	_shown[id] = true
	_queue.push_back({"id": id, "title": title, "icon": icon_tex})
	if not _showing:
		_process_queue()

func _process_queue() -> void:
	if _queue.is_empty():
		_showing = false
		return
	_showing = true

# Estrai il primo elemento e rimuovilo
	var item: Dictionary = _queue[0]
	_queue.remove_at(0)

# Usa accesso a dizionario, non dot-notation
	label.text = "Hai sbloccato l'achievement: %s" % String(item.get("title", ""))

	var tex: Texture2D = item.get("icon", null)
	if tex == null:
			tex = _fallback_medal
	icon.texture = tex

	popup_centered(Vector2(420, 200))
	show()

	await get_tree().create_timer(5.0).timeout
	hide()
	_process_queue()

# Utility se vuoi poter “dimenticare” ciò che è già stato mostrato durante la sessione
func reset_session_shown() -> void:
	_shown.clear()
