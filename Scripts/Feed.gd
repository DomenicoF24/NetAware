# Scripts/Feed.gd
extends Control

@onready var pb_sc = $MainContainer/Indicators/P1
@onready var pb_emp = $MainContainer/Indicators/P2
@onready var pb_priv = $MainContainer/Indicators/P3
@onready var pb_dep = $MainContainer/Indicators/P4

func _ready() -> void:
	# Connessione agli indicatori
	GameManager.connect("indicators_changed", _on_indicators_changed)
	_on_indicators_changed(
		GameManager.spirito_critico,
		GameManager.empatia,
		GameManager.privacy,
		GameManager.dipendenza
	)
	spawn_random_posts(5)   # genera 5 post casuali
	
	# Aggiorna subito con i valori iniziali
	_on_indicators_changed(
		GameManager.spirito_critico,
		GameManager.empatia,
		GameManager.privacy,
		GameManager.dipendenza
	)

func _on_indicators_changed(sc: int, emp: int, priv: int, dep: int) -> void:
	pb_sc.value = sc
	pb_emp.value = emp
	pb_priv.value = priv
	pb_dep.value = dep
	
@onready var posts_container = $MainContainer/FeedColumn/PostsContainer
var post_scene = preload("res://Post.tscn")

func spawn_random_posts(count: int = 5) -> void:
	for i in range(count):
		var template = post_templates[randi() % post_templates.size()]
		var p = post_scene.instantiate()
		posts_container.add_child(p)           # fondamentale prima
		p.set_post_data(template)


var post_templates = [
	{
		"author": "Marco98",
		"content": "Ho trovato questa notizia online... ma sarà vera?",
		"effects_like": {"sc": -5, "dep": +5},
		"effects_report": {"sc": +10, "emp": +5},
		"effects_share": {"sc": -10, "dep": +10},
		"effects_comment": {"emp": +5}
	},
	{
		"author": "NewsBot",
		"content": "Ricorda: non condividere le tue password con nessuno!",
		"effects_like": {"sc": +5, "priv": +5},
		"effects_report": {"sc": -5},
		"effects_share": {"sc": +5, "emp": +5},
		"effects_comment": {"emp": +2}
	},
	{
		"author": "InfluencerX",
		"content": "Questo prodotto funziona al 100%, fidatevi!",
		"effects_like": {"sc": -5, "dep": +5},
		"effects_report": {"sc": +5},
		"effects_share": {"sc": -5, "dep": +5},
		"effects_comment": {"emp": +1}
	},
	{
		"author": "Amico123",
		"content": "Guardate che foto simpatica!",
		"effects_like": {"sc": +2, "emp": +3},
		"effects_report": {"sc": 0},
		"effects_share": {"sc": +1, "dep": +1},
		"effects_comment": {"emp": +2}
	}
]
