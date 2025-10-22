extends CanvasLayer

@onready var panel: PanelContainer = $PanelContainer
@onready var label: Label = $PanelContainer/Label

var is_showing: bool = false

func _ready() -> void:
	# All'avvio il panel deve essere nascosto
	if panel:
		panel.visible = false

func show_message(msg: String, duration: float = 2.0) -> void:
	if not panel or not label:
		printerr("PopupMessaggio: nodi non trovati!")
		return
	
	# Se un messaggio è già in corso, non far partire un altro
	if is_showing:
		return

	is_showing = true
	label.text = msg
	panel.visible = true

	# Aspetta la durata del messaggio
	await get_tree().create_timer(duration).timeout

	# Fai sparire il panel senza usare modulate
	panel.visible = false
	is_showing = false
