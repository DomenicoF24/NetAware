extends Control

@onready var pb_sc = $MainContainer/Indicators/P1
@onready var pb_emp = $MainContainer/Indicators/P2
@onready var pb_priv = $MainContainer/Indicators/P3
@onready var pb_dep = $MainContainer/Indicators/P4
@onready var posts_container = $MainContainer/FeedColumn/PostsContainer
@onready var ideaButton = $MainContainer/Indicators/HBoxContainer5/IdeaButton 
@onready var feedback_label = $MainContainer/Indicators/HBoxContainer5/FeedbackLabel  # 👈 aggiunta Label

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
	spawn_random_posts(15)

func _on_indicators_changed(sc: int, emp: int, priv: int, dep: int) -> void:
	pb_sc.value = sc
	pb_emp.value = emp
	pb_priv.value = priv
	pb_dep.value = dep

var tip_queue: Array[String] = []
var showing := false

func _on_event_logged(text: String) -> void:
	# Mettiamo il tip in coda
	tip_queue.append(text)
	# Se non stiamo mostrando nulla, partiamo subito
	if not showing:
		_show_next_tip()

func _show_next_tip() -> void:
	if tip_queue.is_empty():
		showing = false
		ideaButton.visible = false
		return
	
	showing = true
	var current_text = tip_queue.pop_front()
	feedback_label.text = current_text
	ideaButton.visible = true
	feedback_label.modulate.a = 1.0
	
	# Mostra per 5 secondi
	await get_tree().create_timer(3.5).timeout
	
	# Cancella il testo
	feedback_label.text = ""
	feedback_label.modulate.a = 1.0
	
	# Passa al prossimo tip in coda (se c’è)
	_show_next_tip()

func spawn_random_posts(count: int = 5) -> void:
	# Creiamo una copia dei template disponibili
	var available_posts = post_templates.duplicate()
	
	for i in range(count):
		if available_posts.is_empty():
			break  # Non ci sono più post da spawnare

		# Scegliamo un post casuale dalla lista disponibile
		var index = randi() % available_posts.size()
		var template = available_posts[index]
		
		# Istanzio il post e lo aggiungo al container
		var p = post_scene.instantiate()
		posts_container.add_child(p)
		p.set_post_data(template)
		
		# Rimuovo il template appena usato per evitare duplicati
		available_posts.remove_at(index)


var post_templates = [
	{
		"pic": preload("res://images/man3.png"),
		"author": "@Marco98",
		"content": "Ho trovato questa foto online di New York... ma sarà vera?",
		"time": "2 ore fa",
		"foto": preload("res://images/NY.jpg"),
		"effects_like": {"sc": -10},
		"effects_report": {"sc": +10},
		"effects_share": {"sc": -10, "dep": +10},
		"effects_comment": {"emp": +5},
		"dangerous": true,
		"category": "fake_news",
	},
	{
		"pic": preload("res://images/robot.png"),
		"author": "@NewsBot",
		"content": "Ricorda: non condividere le tue password con nessuno!",
		"time": "5 ore fa",
		"foto": preload("res://images/lock.jpg"),
		"effects_like": {"sc": 5, "priv": +10},
		"effects_report": {"sc": -15},
		"effects_share": {"sc": +15, "dep": +5},
		"effects_comment": {"emp": +5},
		"dangerous": false,
		"category": "privacy_advice",
	},
	{
		"pic": preload("res://images/man1.png"),
		"author": "@InfluencerX",
		"content": "Questo sito funziona al 100%, fidatevi! http://VrsMn.com",
		"time": "30 minuti fa",
		"foto": preload("res://images/soldi.jpg"),
		"effects_like": {"sc": -10},
		"effects_report": {"sc": +15},
		"effects_share": {"sc": -10, "dep": +5},
		"effects_comment": {"emp": -5},
		"dangerous": true,
		"category": "fraud",
	},
	{
		"pic": preload("res://images/man2.png"),
		"author": "@Luc1a_",
		"content": "Guardate che foto simpatica!",
		"time": "23 ore fa",
		"foto": preload("res://images/cat.jpg"),
		"effects_like": {"emp": +5},
		"effects_report": {"sc": -10},
		"effects_share": {"dep": +5},
		"effects_comment": {"emp": +10},
		"dangerous": false,
		"category": "default",
	},
		{
		"pic": preload("res://images/Netw.png"),
		"author": "@NetAware",
		"content": "Se ti stai divertendo lascia un like al post",
		"time": "10 ore fa",
		"foto": preload("res://images/Netw.jpg"),
		"effects_like": {"emp": +20},
		"effects_report": {"sc": -10},
		"effects_share": {"dep": +5},
		"effects_comment": {},
		"dangerous": false,
		"category": "default",
	},
		{
		"pic": preload("res://images/news64.png"),
		"author": "@NetNews",
		"content": "Ultim'ora! L'AI si impossessa dei giornali!",
		"time": "2 minuti fa",
		"foto": preload("res://images/news.jpg"),
		"effects_like": {"emp": +5},
		"effects_report": {"sc": -5},
		"effects_share": {"dep": +5},
		"effects_comment": {"emp": +5},
		"dangerous": false,
		"category": "default",
	},
	
		{
		"pic": preload("res://images/goal64.png"),
		"author": "@Football_24h",
		"content": "Finisce 1-0 la partita di oggi!",
		"time": "5 minuti fa",
		"foto": preload("res://images/calcio.jpeg"),
		"effects_like": {"emp": +10},
		"effects_report": {"sc": -10},
		"effects_share": {"dep": +5},
		"effects_comment": {"emp": +10},
		"dangerous": false,
		"category": "default",
	},
	
		{
		"pic": preload("res://images/gym64.png"),
		"author": "@GymTraining",
		"content": "Iscriviti alla nostra palestra, chiama subito!",
		"time": "20 ore fa",
		"foto": preload("res://images/gym.jpg"),
		"effects_like": {"emp": +5},
		"effects_report": {"sc": -10},
		"effects_share": {"dep": +5},
		"effects_comment": {"emp": +5},
		"dangerous": false,
		"category": "default",
	},
		{
		"pic": preload("res://images/game64.png"),
		"author": "@GameDev011",
		"content": "Scarica subito il nostro NUOVISSIMO gioco! https://Vrs.Ga",
		"time": "12 ore fa",
		"foto": preload("res://images/game.jpg"),
		"effects_like": {},
		"effects_report": {"sc": +15},
		"effects_share": {"dep": +5, "sc": -10},
		"effects_comment": {"emp": +5},
		"dangerous": true,
		"category": "fraud",
	},
			{
		"pic": preload("res://images/robot.png"),
		"author": "@NewsBot",
		"content": "Verifica sempre le fonti dei post",
		"time": "51 minuti fa",
		"foto": preload("res://images/bot2.jpg"),
		"effects_like": {"emp": +5, "priv": +10},
		"effects_report": {"sc": -15},
		"effects_share": {"dep": +5, "sc": +5},
		"effects_comment": {"emp": +5},
		"dangerous": false,
		"category": "privacy_advice",
	},
			{
		"pic": preload("res://images/news64.png"),
		"author": "@NetNews",
		"content": "Proteste di oggi per il diritto allo studio",
		"time": "2 minuti fa",
		"foto": preload("res://images/studio.jpg"),
		"effects_like": {"emp": +5},
		"effects_report": {"sc": +10},
		"effects_share": {"dep": +5, "sc": -15},
		"effects_comment": {"sc": -5},
		"dangerous": true,
		"category": "fake_news",
	},
	{
		"pic": preload("res://images/woman1.png"),
		"author": "@Anna23",
		"content": "Condividi la tua password con un amico fidato? Meglio di no!",
		"time": "1 ora fa",
		"foto": preload("res://images/password.jpg"),
		"effects_like": {"sc": +5, "priv": +5},
		"effects_report": {"sc": -5},
		"effects_share": {"sc": +5, "emp": +5},
		"effects_comment": {"emp": +2},
		"dangerous": false,
		"category": "privacy_advice",
	},
	{
		"pic": preload("res://images/man4.png"),
		"author": "@Luca99",
		"content": "Hai vinto un iPhone gratis! Clicca qui subito!",
		"time": "30 min fa",
		"foto": preload("res://images/apple-iphone-14-pro-max-256gb-gold-europa.jpg"),
		"effects_like": {"sc": -15, "dep": +5},
		"effects_report": {"sc": +15},
		"effects_share": {"sc": -20, "dep": +10},
		"effects_comment": {"emp": +1},
		"dangerous": true,
		"category": "fraud",
	},
	{
		"pic": preload("res://images/woman2.png"),
		"author": "@GiuliaX",
		"content": "Ecco 5 modi per proteggere la tua privacy online.",
		"time": "5 ore fa",
		"foto": preload("res://images/privacy-policy-psb-consulting-gdpr-nuovo-regolamento-europeo.jpeg"),
		"effects_like": {"sc": +5, "priv": +10},
		"effects_report": {"sc": 0},
		"effects_share": {"sc": +2, "emp": +2},
		"effects_comment": {"emp": +3},
		"dangerous": false,
		"category": "privacy_advice",
	},
	{
		"pic": preload("res://images/man5.png"),
		"author": "@MarcoTech",
		"content": "Questo prodotto funziona al 100%! Fidatevi!",
		"time": "20 min fa",
		"foto": preload("res://images/fulcronday3-012-1-1020x1024.jpg"),
		"effects_like": {"sc": -5, "dep": +5},
		"effects_report": {"sc": +5},
		"effects_share": {"sc": -5, "dep": +5},
		"effects_comment": {"emp": +1},
		"dangerous": true,
		"category": "fake_news",
	},
	{
		"pic": preload("res://images/woman3.png"),
		"author": "@Elisa07",
		"content": "Non cliccare su link sospetti ricevuti in chat, potresti essere truffato!",
		"time": "10 min fa",
		"foto": preload("res://images/Don&#039;t Click Poster.png"),
		"effects_like": {"sc": +5, "priv": +5},
		"effects_report": {"sc": +10},
		"effects_share": {"sc": -5},
		"effects_comment": {"emp": +2},
		"dangerous": true,
		"category": "fraud",
	}
	
]
