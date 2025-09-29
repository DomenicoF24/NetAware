extends Control

@onready var author_label = $PostPanel/PostLayout/HBoxContainer/AuthorLabel
@onready var profilePic = $PostPanel/PostLayout/HBoxContainer/ProfilePic
@onready var foto = $PostPanel/PostLayout/foto
@onready var content_label = $PostPanel/PostLayout/ContentLabel
@onready var time_label = $PostPanel/PostLayout/HBoxContainer/TimeLabel
@onready var btn_like = $PostPanel/PostLayout/ButtonsRow/Like
@onready var btn_report = $PostPanel/PostLayout/ButtonsRow/Segnala
@onready var btn_share = $PostPanel/PostLayout/ButtonsRow/Condividi
@onready var btn_comment = $PostPanel/PostLayout/ButtonsRow/Commenta

var data = {} # conterrà le info del post (autore, testo, effetti)

func _ready() -> void:
	if author_label == null:
		print("ERROR: author_label è null! Verifica i percorsi")
	# Collega i pulsanti alle funzioni
	btn_like.pressed.connect(_on_like_pressed)
	btn_report.pressed.connect(_on_report_pressed)
	btn_share.pressed.connect(_on_share_pressed)
	btn_comment.pressed.connect(_on_comment_pressed)

func set_post_data(post_data: Dictionary) -> void:
	# Inizializza il contenuto del post
	data = post_data
	profilePic.texture_normal = data.get("pic", preload("res://images/pic.png"))
	author_label.text = data.get("author", "Anonimo")
	content_label.text = data.get("content", "Post vuoto")
	time_label.text = data.get("time", "X ore fa")
	foto.texture = data.get("foto", null)

func _on_like_pressed() -> void:
	if data.has("effects_like"):
		GameManager.apply_effect(
			data["effects_like"],
			"Hai messo Like al post di %s" % data.get("author", "utente"))
			
		if data.has("category"):
			var tip = GameManager.get_tip(data["category"])
			GameManager.emit_signal("event_logged", tip)
			
		EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000))) # posizione di partenza, es. centro-basso schermo)
		EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000))) # posizione di partenza, es. centro-basso schermo)
		EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000)))

func _on_report_pressed() -> void:
	if data.has("effects_report"):
		GameManager.apply_effect(
			data["effects_report"],
			"Hai segnalato il post di %s" % data.get("author", "utente"))
			
		if data.has("category"):
			var tip = GameManager.get_tip(data["category"])
			GameManager.emit_signal("event_logged", tip)
			
		EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))) # posizione di partenza, es. centro-basso schermo)
		EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))) # posizione di partenza, es. centro-basso schermo)
		EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))

func _on_share_pressed() -> void:
	if data.has("effects_share"):
		GameManager.apply_effect(
			data["effects_share"],
			"Hai condiviso un contenuto: rifletti sempre sulle conseguenze.")
			
		if data.has("category"):
			var tip = GameManager.get_tip(data["category"])
			GameManager.emit_signal("event_logged", tip)
			
		EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))) # posizione di partenza, es. centro-basso schermo)
		EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))) # posizione di partenza, es. centro-basso schermo)
		EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))

func _on_comment_pressed() -> void:
	if data.has("effects_comment"):
		GameManager.apply_effect(
			data["effects_comment"],
			"Hai commentato il post: ottimo per l'empatia!")
			
		if data.has("category"):
			var tip = GameManager.get_tip(data["category"])
			GameManager.emit_signal("event_logged", tip)
			
		EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))) # posizione di partenza, es. centro-basso schermo)
		EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))) # posizione di partenza, es. centro-basso schermo)
		EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
		EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000)))
