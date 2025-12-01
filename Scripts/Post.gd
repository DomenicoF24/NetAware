extends Control
class_name PostCard

@onready var author_label = $PostPanel/PostLayout/HBoxContainer/AuthorLabel
@onready var profilePic = $PostPanel/PostLayout/HBoxContainer/ProfilePic
@onready var foto = $PostPanel/PostLayout/foto
@onready var content_label = $PostPanel/PostLayout/TextBox/ContentLabel
@onready var time_label = $PostPanel/PostLayout/HBoxContainer/TimeLabel
@onready var likes = $PostPanel/PostLayout/MiPiace
@onready var btn_like = $PostPanel/PostLayout/ButtonBg/ButtonsRow/Like
@onready var btn_report = $PostPanel/PostLayout/ButtonBg/ButtonsRow/Segnala
@onready var btn_share = $PostPanel/PostLayout/ButtonBg/ButtonsRow/Condividi
@onready var btn_comment = $PostPanel/PostLayout/ButtonBg/ButtonsRow/Commenta
@onready var verified = $PostPanel/PostLayout/HBoxContainer/Verifiedimg
var pressed_buttons := {}  # tiene traccia dei bottoni già premuti

var data = {} # conterrà le info del post (autore, testo, effetti)

@onready var top: Control = $PostPanel/PostLayout/HBoxContainer
@onready var like: Control = $PostPanel/PostLayout/MiPiace
@onready var comments: Control = $PostPanel/PostLayout/TextBox
@onready var bottoni: Control = $PostPanel/PostLayout/ButtonBg
@onready var Post: Control = $PostPanel

var post_label: String = ""
var post_category: String = "default"

func _ready() -> void:
	if author_label == null:
		print("ERROR: author_label è null! Verifica i percorsi")
	# Collega i pulsanti alle funzioni
	btn_like.pressed.connect(_on_like_pressed)
	btn_report.pressed.connect(_on_report_pressed)
	btn_share.pressed.connect(_on_share_pressed)
	btn_comment.pressed.connect(_on_comment_pressed)

func get_tutorial_targets() -> Dictionary:
	return {
		"top": top,
		"like": like,
		"comments": comments,
		"bottoni": bottoni,
		"Post": Post,
	}

func set_post_data(post_data: Dictionary) -> void:
	# Inizializza il contenuto del post
	data = post_data
	profilePic.texture_normal = data.get("pic", preload("res://images/pic.png"))
	author_label.text = data.get("author", "Anonimo")
	content_label.text = data.get("content", "Post vuoto")
	time_label.text = data.get("time", "X ore fa")
	likes.text = data.get("likes", "Piace a 20mila persone")
	foto.texture = data.get("foto", null)
	post_label = data.get("label", data.get("author", "Post"))
	post_category = data.get("category", "default")
	# Controllo se mostrare il badge verificato
	if data.has("verified") and verified != null:
		verified.visible = data["verified"]
	else:
		verified.visible = false

func _on_like_pressed() -> void:
	if pressed_buttons.has("like"):
		return

	var effect: Dictionary = {}
	if data.has("effects_like"):
		effect = data["effects_like"]

	if not effect.is_empty():
		GameManager.apply_effect(effect)

	GameManager.log_feed_action(post_label, "Like", effect, post_category)

	pressed_buttons["like"] = true
	btn_like.texture_normal = preload("res://images/cuore2.png")
	btn_like.disabled = true  # opzionale: impedisce di premere di nuovo

	EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/cuori.png"),
		Vector2(randi_range(0, 1000), randi_range(0, 1000))
	)


func _on_report_pressed() -> void:
	if pressed_buttons.has("report"):
		return

	var effect: Dictionary = {}
	if data.has("effects_report"):
		effect = data["effects_report"]

	if not effect.is_empty():
		GameManager.apply_effect(effect)

	GameManager.log_feed_action(post_label, "Segnala", effect, post_category)

	pressed_buttons["report"] = true
	btn_report.texture_normal = preload("res://images/segnala2.png")
	btn_report.disabled = true

	EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/alarm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)


func _on_share_pressed() -> void:
	if pressed_buttons.has("share"):
		return

	var effect: Dictionary = {}
	if data.has("effects_share"):
		effect = data["effects_share"]

	if not effect.is_empty():
		GameManager.apply_effect(effect)

	GameManager.log_feed_action(post_label, "Condividi", effect, post_category)

	pressed_buttons["share"] = true
	btn_share.texture_normal = preload("res://images/condividi3.png")
	btn_share.disabled = true

	EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/share.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)


func _on_comment_pressed() -> void:
	if pressed_buttons.has("comment"):
		return

	var effect: Dictionary = {}
	if data.has("effects_comment"):
		effect = data["effects_comment"]

	if not effect.is_empty():
		GameManager.apply_effect(effect)

	GameManager.log_feed_action(post_label, "Commento", effect, post_category)

	pressed_buttons["comment"] = true
	btn_comment.texture_normal = preload("res://images/commenta2.png")
	btn_comment.disabled = true  # opzionale: impedisce di premere di nuovo

	EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
	EffectsManager.spawn_effect(
		preload("res://images/comm.png"),
		Vector2(randi_range(0, 1400), randi_range(0, 1000))
	)
