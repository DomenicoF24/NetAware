extends PopupPanel

@onready var entries_container: VBoxContainer = $MarginContainer/VBoxContainer/NotePage/MarginContainer/ScrollContainer/EntriesContainer
@onready var close_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/Button
@onready var title_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var scroll: ScrollContainer = $MarginContainer/VBoxContainer/NotePage/MarginContainer/ScrollContainer

func _ready() -> void:
	if close_button and not close_button.pressed.is_connected(_on_close_pressed):
		close_button.pressed.connect(_on_close_pressed)

	if not GameManager.feed_action_logged.is_connected(_on_feed_action_logged):
		GameManager.feed_action_logged.connect(_on_feed_action_logged)


func _on_close_pressed() -> void:
	hide()


# VERSIONE SEMPLICE: una sola stringa, tutta dello stesso colore
func add_log_entry(text: String) -> void:
	if entries_container == null:
		push_error("EntriesContainer è null in add_log_entry().")
		return

	var rtl := RichTextLabel.new()
	rtl.bbcode_enabled = false
	rtl.fit_content = true
	rtl.autowrap_mode = TextServer.AUTOWRAP_OFF
	rtl.text = text

	entries_container.add_child(rtl)
	_scroll_to_bottom_deferred()


# VERSIONE DETTAGLIATA: colori per "Corretto/Errore" e per i delta
# deltas è un dizionario del tipo: {"EM": 5, "SC": -3}
func add_log_entry_detailed(post_label: String, action: String, result: String, deltas: Dictionary = {}) -> void:
	if entries_container == null:
		push_error("EntriesContainer è null in add_log_entry_detailed().")
		return

	var is_error := result.to_lower() == "errore"
	var result_color: Color = Color(0.8, 0.1, 0.1) if is_error else Color(0.1, 0.6, 0.1)
	var result_bbcode := "[color=%s]%s[/color]" % [result_color.to_html(), result]

	var parts: Array[String] = []
	parts.append(post_label)
	parts.append(action)
	parts.append(result_bbcode)

	for stat_name in deltas.keys():
		var delta: int = int(deltas[stat_name])
		var delta_color: Color = Color(0.8, 0.1, 0.1) if delta < 0 else Color(0.1, 0.6, 0.1)
		var delta_bbcode := "[color=%s]%+d[/color]" % [delta_color.to_html(), delta]
		parts.append("%s %s" % [str(stat_name), delta_bbcode])

	var full_text := " / ".join(parts)

	var rtl := RichTextLabel.new()
	rtl.bbcode_enabled = true
	rtl.fit_content = true
	rtl.autowrap_mode = TextServer.AUTOWRAP_OFF
	# rtl.label_settings = preload("res://fonts/NotebookFont.tres")

	rtl.text = full_text

	entries_container.add_child(rtl)
	_scroll_to_bottom_deferred()

func _on_feed_action_logged(entry: Dictionary) -> void:
	var post_label := String(entry.get("post_label", "Post"))
	var action := String(entry.get("action", ""))
	var result := String(entry.get("result", ""))
	var deltas: Dictionary = entry.get("deltas", {})

	add_log_entry_detailed(post_label, action, result, deltas)


func _scroll_to_bottom_deferred() -> void:
	if scroll == null:
		return
	call_deferred("_scroll_to_bottom")


func _scroll_to_bottom() -> void:
	if scroll == null:
		return
	var bar := scroll.get_v_scroll_bar()
	if bar:
		bar.value = bar.max_value

func clear_log() -> void:
	if entries_container == null:
		return

	for child in entries_container.get_children():
		child.queue_free()
