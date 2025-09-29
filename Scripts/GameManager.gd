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
var tips_by_category := {
	"fake_news": [
		"Verifica sempre la fonte originale.",
		"Attento ai titoli clickbait.",
		"Uno screenshot può essere manipolato.",
		"Controlla se la notizia è riportata anche da fonti affidabili.",
		"Non fermarti solo al titolo, leggi l’articolo completo.",
		"Le immagini possono essere manipolate: cerca la fonte originale.",
		"Diffida dalle notizie che fanno leva solo sulle emozioni.",
		"Verifica la data di pubblicazione: potrebbe essere una notizia vecchia riciclata."
	],
	"privacy_advice": [
		"Non condividere mai la tua password.",
		"Controlla le impostazioni della privacy.",
		"Non accettare richieste da sconosciuti.",
		"Non condividere informazioni personali con sconosciuti online.",
		"Usa password diverse per siti diversi.",
		"Attiva l’autenticazione a due fattori quando possibile.",
		"Controlla le impostazioni di privacy sui social network.",
		"Non pubblicare foto che rivelano la tua posizione in tempo reale."
	],
	"fraud": [
		"Diffida da offerte troppo belle per essere vere.",
		"Non cliccare su link sospetti o ricevuti via messaggi privati.",
		"Controlla sempre l’indirizzo del sito prima di inserire dati personali.",
		"Se ti chiedono denaro in anticipo, probabilmente è una truffa.",
		"Verifica che le email provengano davvero dall’ente ufficiale."
	],
	"default": [
		"Verifica sempre la fonte originale.",
		"Attento ai titoli clickbait.",
		"Uno screenshot può essere manipolato.",
		"Condividi solo ciò che leggeresti fino in fondo.",
		"Ricorda: il rispetto online vale quanto quello offline."
	]
}

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
	
	if reason != "":
		emit_signal("event_logged", reason)
	else:
		# Mostra un tip legato alla categoria
		emit_signal("event_logged", get_tip("category"))

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
	


func get_tip(category: String) -> String:
	if tips_by_category.has(category):
		var tips = tips_by_category[category]
		return tips[randi() % tips.size()]
	else:
		var tips = tips_by_category["default"]
		return tips[randi() % tips.size()]
