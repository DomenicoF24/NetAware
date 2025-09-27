extends Node

# Segnali
signal indicators_changed(sc, emp, priv, dep)
signal event_logged(text)

# Valori iniziali
var spirito_critico := 50
var empatia := 50
var privacy := 50
var dipendenza := 50

# Piccoli suggerimenti educativi
var tips := [
	"Verifica sempre la fonte originale.",
	"Attento ai titoli clickbait.",
	"Uno screenshot può essere manipolato.",
	"Condividi solo ciò che leggeresti fino in fondo."
]

func _ready() -> void:
	print("[GameManager] ready")
	emit_signal("indicators_changed", spirito_critico, empatia, privacy, dipendenza)

# Applica effetti agli indicatori. Esempio: {"sc": +5, "dep": -3}
func apply_effect(effect: Dictionary, reason: String = "") -> void:
	if effect.has("sc"):
		spirito_critico = clamp(spirito_critico + int(effect["sc"]), 0, 100)
	if effect.has("emp"):
		empatia = clamp(empatia + int(effect["emp"]), 0, 100)
	if effect.has("priv"):
		privacy = clamp(privacy + int(effect["priv"]), 0, 100)
	if effect.has("dep"):
		dipendenza = clamp(dipendenza + int(effect["dep"]), 0, 100)

	emit_signal("indicators_changed", spirito_critico, empatia, privacy, dipendenza)
	
		#se c'è una motivazione, la usiamo come feedback
	if reason != "":
		emit_signal("event_logged", reason)
	else:
		#se non c'è, mostriamo un tip educativo random
		emit_signal("event_logged", get_random_tip())
	
	if spirito_critico == 100:
		_show_achievement("Hai guadagnato la medaglia 'PENSATORE CRITICO'", preload("res://images/medal.png"))
	if empatia == 100:
		_show_achievement("Hai guadagnato la medaglia 'EMPATICO DIGITALE'", preload("res://images/medal.png"))
	if privacy == 100:
		_show_achievement("Hai guadagnato la medaglia 'GUARDIANO DELLA PRIVACY'", preload("res://images/medal.png"))
	if dipendenza == 100:
		_show_achievement("Hai guadagnato la medaglia 'MAESTRO DELL’EQUILIBRIO'", preload("res://images/medal.png"))
	if spirito_critico == 100 and empatia == 100 and privacy == 100 and dipendenza == 100:
		_show_final_achievement("Hai guadagnato la medaglia 'ESPERTO SOCIAL'", preload("res://images/trophy.png"))

#DA FIXARE
func _show_final_achievement(title: String, tex: Texture2D) -> void:
	var popup = get_tree().root.get_node("Feed/AchievementPopup")
	popup.show_achievement(title, tex)
	
	# Effetti visivi
	var fireworks = get_tree().root.get_node("Feed/EffectsLayer/Fireworks")
	fireworks.emitting = true
	# Aspetta la durata del popup + effetti
	await get_tree().create_timer(5.0).timeout
	# Stop effetti
	fireworks.emitting = false
	# Torna alla schermata principale
	# get_tree().change_scene("res://Scenes/MainMenu.tscn")



func _show_achievement(text: String, tex: Texture2D) -> void:
	var popup = get_tree().root.get_node("Feed/AchievementPopup")
	popup.show_achievement(text, tex)
	


func get_random_tip() -> String:
	if tips.is_empty():
		return ""
	return tips[randi() % tips.size()]
