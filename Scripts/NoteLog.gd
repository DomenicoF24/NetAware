extends PopupPanel

@onready var entries_container: VBoxContainer = $MarginContainer/VBoxContainer/NotePage/MarginContainer/ScrollContainer/EntriesContainer
@onready var close_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/Button
@onready var title_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var scroll: ScrollContainer = $MarginContainer/VBoxContainer/NotePage/MarginContainer/ScrollContainer

func _ready() -> void:
	# Entry di test (puoi toglierla)
	add_log_entry_detailed(1, "Commento", "Corretto", {"EM": +5})
	add_log_entry_detailed(3, "Like", "Corretto", {"EM": +5, "SC": +10})
	add_log_entry_detailed(5, "Like", "Errore", {"PR": -5, "SC": -10})


	if close_button and not close_button.pressed.is_connected(_on_close_pressed):
		close_button.pressed.connect(_on_close_pressed)


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
func add_log_entry_detailed(post_id: int, action: String, result: String, deltas: Dictionary = {}) -> void:
	if entries_container == null:
		push_error("EntriesContainer è null in add_log_entry_detailed().")
		return

	# Colore della parola "Corretto"/"Errore"
	var is_error := result.to_lower() == "errore"
	var result_color: Color = Color(0.8, 0.1, 0.1) if is_error else Color(0.1, 0.6, 0.1)
	var result_bbcode := "[color=%s]%s[/color]" % [result_color.to_html(), result]

	var parts: Array[String] = []
	parts.append("Post %d" % post_id)
	parts.append(action)
	parts.append(result_bbcode)

	# Aggiungi tutte le stat modificate (0, 1, 2, 3…)
	for stat_name in deltas.keys():
		var delta: int = int(deltas[stat_name])
		var delta_color: Color = Color(0.8, 0.1, 0.1) if delta < 0 else Color(0.1, 0.6, 0.1)
		var delta_bbcode := "[color=%s]%+d[/color]" % [delta_color.to_html(), delta]

		# es: "EM +5", "SC -3"
		parts.append("%s %s" % [str(stat_name), delta_bbcode])

	var full_text := " / ".join(parts)

	var rtl := RichTextLabel.new()
	rtl.bbcode_enabled = true
	rtl.fit_content = true
	rtl.autowrap_mode = TextServer.AUTOWRAP_OFF
	# se hai il font notebook:
	# rtl.label_settings = preload("res://fonts/NotebookFont.tres")

	rtl.text = full_text

	entries_container.add_child(rtl)
	_scroll_to_bottom_deferred()


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
