extends Node

# Segnali: la UI li userà per aggiornarsi
signal indicators_changed(sc, emp, priv, dep)
signal event_logged(text)

# Valori iniziali (0..100)
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
	if effect.has("sc"):   spirito_critico = clamp(spirito_critico + int(effect["sc"]), 0, 100)
	if effect.has("emp"):  empatia         = clamp(empatia         + int(effect["emp"]), 0, 100)
	if effect.has("priv"): privacy         = clamp(privacy         + int(effect["priv"]), 0, 100)
	if effect.has("dep"):  dipendenza      = clamp(dipendenza      + int(effect["dep"]), 0, 100)

	emit_signal("indicators_changed", spirito_critico, empatia, privacy, dipendenza)
	if reason != "":
		emit_signal("event_logged", reason)

func get_random_tip() -> String:
	if tips.is_empty(): return ""
	return tips[randi() % tips.size()]
