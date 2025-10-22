extends Control

@onready var author_label = $PostPanel/PostLayout/HBoxContainer/AuthorLabel
@onready var profilePic = $PostPanel/PostLayout/HBoxContainer/ProfilePic
@onready var foto = $PostPanel/PostLayout/foto
@onready var content_label = $PostPanel/PostLayout/TextBox/ContentLabel
@onready var time_label = $PostPanel/PostLayout/HBoxContainer/TimeLabel
@onready var btn_like = $PostPanel/PostLayout/ButtonBg/ButtonsRow/Like
@onready var btn_report = $PostPanel/PostLayout/ButtonBg/ButtonsRow/Segnala
@onready var btn_share = $PostPanel/PostLayout/ButtonBg/ButtonsRow/Condividi
@onready var btn_comment = $PostPanel/PostLayout/ButtonBg/ButtonsRow/Commenta
@onready var verified = $PostPanel/PostLayout/HBoxContainer/Verifiedimg
var pressed_buttons := {}  # tiene traccia dei bottoni già premuti

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
	# Controllo se mostrare il badge verificato
	if data.has("verified") and verified != null:
		verified.visible = data["verified"]
	else:
		verified.visible = false

func _on_like_pressed() -> void:
	# Controlla se è già stato premuto
	if pressed_buttons.has("like"):
		return
	if data.has("effects_like"):
		GameManager.apply_effect(
			data["effects_like"],
			"Hai messo Like al post di %s" % data.get("author", "utente"))
		pressed_buttons["like"] = true
		btn_like.texture_normal = preload("res://images/cuore2.png")
		btn_like.disabled = true  # opzionale: impedisce di premere di nuovo
			
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
	if pressed_buttons.has("report"):
		return
		
	if data.has("effects_report"):
		GameManager.apply_effect(
			data["effects_report"],
			"Hai segnalato il post di %s" % data.get("author", "utente"))
		pressed_buttons["report"] = true
		btn_report.texture_normal = preload("res://images/segnala2.png")
		btn_report.disabled = true  # opzionale: impedisce di premere di nuovo
			
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
	if pressed_buttons.has("share"):
		return
		
	if data.has("effects_share"):
		GameManager.apply_effect(
			data["effects_share"],
			"Hai condiviso un contenuto: rifletti sempre sulle conseguenze.")
			
		pressed_buttons["share"] = true
		btn_share.texture_normal = preload("res://images/condividi3.png")
		btn_share.disabled = true  # opzionale: impedisce di premere di nuovo
			
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
	if pressed_buttons.has("comment"):
		return
		
	if data.has("effects_comment"):
		GameManager.apply_effect(
			data["effects_comment"],
			"Hai commentato il post: ottimo per l'empatia!")
			
		pressed_buttons["comment"] = true
		btn_comment.texture_normal = preload("res://images/commenta2.png")
		btn_comment.disabled = true  # opzionale: impedisce di premere di nuovo
			
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
