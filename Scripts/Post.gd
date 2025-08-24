extends Control

@onready var author_label = $PostPanel/PostLayout/AuthorLabel
@onready var content_label = $PostPanel/PostLayout/ContentLabel
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
	author_label.text = data.get("author", "Anonimo")
	content_label.text = data.get("content", "Post vuoto")

func _on_like_pressed() -> void:
	if data.has("effects_like"):
		GameManager.apply_effect(data["effects_like"], "Like su post")

func _on_report_pressed() -> void:
	if data.has("effects_report"):
		GameManager.apply_effect(data["effects_report"], "Segnalazione post")

func _on_share_pressed() -> void:
	if data.has("effects_share"):
		GameManager.apply_effect(data["effects_share"], "Condivisione post")
		
func _on_comment_pressed() -> void:
	if data.has("effects_comment"):
		GameManager.apply_effect(data["effects_comment"], "Commenta post")
