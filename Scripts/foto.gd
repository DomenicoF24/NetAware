extends TextureRect

@onready var popup = $Post/PopupPanel
@onready var popup_image = $Post/PopupPanel/imgGrande

func _ready():
	# Assicuriamoci che il popup sia nascosto all'inizio
	popup.hide()

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		show_popup()

func show_popup():
	popup_image.texture = texture  # usa la stessa immagine del TextureRect
	popup.popup_centered()         # apre il popup al centro

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		popup.hide()
