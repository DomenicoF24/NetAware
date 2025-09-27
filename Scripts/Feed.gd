extends Control

@onready var pb_sc = $MainContainer/Indicators/P1
@onready var pb_emp = $MainContainer/Indicators/P2
@onready var pb_priv = $MainContainer/Indicators/P3
@onready var pb_dep = $MainContainer/Indicators/P4
@onready var posts_container = $MainContainer/FeedColumn/PostsContainer
@onready var feedback_label = $MainContainer/Indicators/FeedbackLabel  # 👈 aggiunta Label

var post_scene = preload("res://Post.tscn")

func _ready() -> void:
	# Connessione agli indicatori
	GameManager.connect("indicators_changed", _on_indicators_changed)
	_on_indicators_changed(
		GameManager.spirito_critico,
		GameManager.empatia,
		GameManager.privacy,
		GameManager.dipendenza
	)

	# 👇 Connessione al segnale educativo
	GameManager.connect("event_logged", _on_event_logged)

	# Genera 5 post casuali
	spawn_random_posts(20)

func _on_indicators_changed(sc: int, emp: int, priv: int, dep: int) -> void:
	pb_sc.value = sc
	pb_emp.value = emp
	pb_priv.value = priv
	pb_dep.value = dep

func _on_event_logged(text: String) -> void:
	feedback_label.text = text
	feedback_label.modulate.a = 1.0  # Assicuriamoci che sia completamente visibile
	
	# Aspetta 5 secondi con il tip visibile
	await get_tree().create_timer(3.0).timeout
	
	# Fade out graduale in 1 secondo
	#var fade_time := 1.0
	#var timer := 0.0
	#while timer < fade_time:
	#	var delta := get_process_delta_time()
	#	timer += delta
	#	feedback_label.modulate.a = clamp(1.0 - timer/fade_time, 0, 1)
	#	await get_tree().process_frame  # aspetta il prossimo frame
	
	# Alla fine nascondiamo il testo
	feedback_label.text = ""
	feedback_label.modulate.a = 1.0  # reset per il prossimo tip

func spawn_random_posts(count: int = 20) -> void:
	for i in range(count):
		var template = post_templates[randi() % post_templates.size()]
		var p = post_scene.instantiate()
		posts_container.add_child(p)           # fondamentale prima
		p.set_post_data(template)

var post_templates = [
	{
		"author": "@Marco98",
		"content": "Ho trovato questa notizia online... ma sarà vera?",
		"time": "2 ore fa",
		"effects_like": {"sc": -5, "dep": +5},
		"effects_report": {"sc": +10, "emp": +5},
		"effects_share": {"sc": -10, "dep": +10},
		"effects_comment": {"emp": +5}
	},
	{
		"author": "@NewsBot",
		"content": "Ricorda: non condividere le tue password con nessuno!",
		"time": "5 ore fa",
		"effects_like": {"sc": +5, "priv": +5},
		"effects_report": {"sc": -5},
		"effects_share": {"sc": +5, "emp": +5},
		"effects_comment": {"emp": +2}
	},
	{
		
		"author": "@InfluencerX",
		"content": "Questo sito funziona al 100%, fidatevi! http://VrsMn.com",
		"time": "30 minuti fa",
		"effects_like": {"sc": -5, "dep": +5},
		"effects_report": {"sc": +5},
		"effects_share": {"sc": -5, "dep": +5},
		"effects_comment": {"emp": +1}
	},
	{
		"author": "@Amico123",
		"content": "Guardate che foto simpatica!",
		"time": "23 ore fa",
		"effects_like": {"sc": +2, "emp": +3},
		"effects_report": {"sc": 0},
		"effects_share": {"sc": +1, "dep": +1},
		"effects_comment": {"emp": +2}
	}
]
