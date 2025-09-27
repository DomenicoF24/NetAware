extends PopupPanel

@onready var label = $Label
@onready var icon = $TextureRect

# Dizionario per tenere traccia degli achievement mostrati
var shown_achievements := {}

func show_achievement(title: String, icon_tex: Texture2D) -> void:
	# Se l'achievement è già stato mostrato, esce
	if shown_achievements.has(title):
		return

	# Segna come mostrato
	shown_achievements[title] = true

	label.text = title
	icon.texture = icon_tex
	popup_centered(Vector2(400, 200))
	show()

	# Lo fa sparire dopo 3 secondi
	await get_tree().create_timer(5.0).timeout
	hide()
