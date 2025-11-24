extends PopupPanel

@onready var vbox_messages: VBoxContainer = $MarginContainer/VBoxRoot/ScrollContainer/VBoxMessages
@onready var label_empty: Label = $MarginContainer/VBoxRoot/LabelEmpty
@onready var btn_close: Button = $MarginContainer/VBoxRoot/HBoxHeader/ButtonClose

var _card_scene := preload("res://Scenes/MessageCard.tscn")

func _ready() -> void:
	btn_close.pressed.connect(hide)

	# ascolta i messaggi aggiunti/gestiti
	if not GameManager.message_added.is_connected(_on_message_added):
		GameManager.message_added.connect(_on_message_added)
	if not GameManager.message_handled.is_connected(_on_message_handled):
		GameManager.message_handled.connect(_on_message_handled)

	_refresh_list()

func open_window() -> void:
	_refresh_list()
	popup_centered()
	move_to_foreground()

func _refresh_list() -> void:
	for child in vbox_messages.get_children():
		child.queue_free()

	var ids: Array = GameManager.get_pending_messages()
	ids.sort()

	label_empty.visible = ids.is_empty()

	for id in ids:
		var data: Dictionary = GameManager.get_message_data(id)
		var card := _card_scene.instantiate() as MessageCard
		vbox_messages.add_child(card)
		card.setup_from_data(id, data)
		card.action_chosen.connect(_on_card_action_chosen)

func _on_card_action_chosen(message_id: String, action: String) -> void:
	GameManager.handle_message(message_id, action)

func _on_message_added(id: String) -> void:
	_refresh_list()

func _on_message_handled(id: String, action: String) -> void:
	_refresh_list()
