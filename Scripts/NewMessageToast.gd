extends Control
class_name NewMessageToast

@onready var panel: Panel = $Panel
@onready var label: Label = $Panel/Label

var _showing: bool = false

func _ready() -> void:
	hide()
	modulate.a = 0.0

func show_toast(message: String) -> void:
	label.text = message

	# se è già in animazione, resetta
	_showing = true
	show()
	modulate.a = 0.0

	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2)   # fade-in 0.2s
	tween.tween_interval(5.0)                            # resta visibile 2s
	tween.tween_property(self, "modulate:a", 0.0, 0.2)   # fade-out 0.2s
	tween.finished.connect(func():
		_showing = false
		hide())
