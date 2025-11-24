
extends PanelContainer
class_name MessageCard

signal action_chosen(message_id: String, action: String)

@export var message_id: String = ""

@onready var profile_pic: TextureRect = $HBoxContainer/ProfilePic
@onready var name_label: Label = $HBoxContainer/VBoxText/LabelName
@onready var text_label: Label = $HBoxContainer/VBoxText/LabelText
@onready var btn_ignore: Button = $HBoxContainer/VBoxButtons/ButtonIgnore
@onready var btn_reply: Button = $HBoxContainer/VBoxButtons/ButtonReply
@onready var btn_report: Button = $HBoxContainer/VBoxButtons/ButtonReport

func _ready() -> void:
	# Collega i bottoni alle azioni
	btn_ignore.pressed.connect(func(): _emit_action("ignora"))
	btn_reply.pressed.connect(func(): _emit_action("rispondi"))
	btn_report.pressed.connect(func(): _emit_action("segnala"))

func setup_from_data(id: String, data: Dictionary) -> void:
	message_id = id

	var sender_name := String(data.get("sender_name", "Utente"))
	var text := String(data.get("text", ""))
	var avatar_path := String(data.get("avatar_icon", ""))  # icona profilo opzionale

	name_label.text = sender_name
	text_label.text = text

	var tex: Texture2D = null
	if avatar_path != "" and ResourceLoader.exists(avatar_path):
		tex = load(avatar_path)
	profile_pic.texture = tex

	# Tooltip con info riassuntiva
	tooltip_text = "%s:\n%s" % [sender_name, text]

func _emit_action(action: String) -> void:
	if message_id == "":
		return
	emit_signal("action_chosen", message_id, action)
