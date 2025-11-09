extends PanelContainer
class_name AchievementCard

@export var achievement_id: String = ""

@onready var _icon: TextureRect = $VBoxContainer/Icon
@onready var _title: Label = $VBoxContainer/Title
@onready var _lock: ColorRect = $ColorRect

func setup_from_data(id: String, data: Dictionary, unlocked: bool) -> void:
	achievement_id = id
	_title.text = String(data.get("name", id))
	var _unlocked := Achievement.is_unlocked(id)
	_lock.visible = not _unlocked
	
	var how := String (data.get("how", ""))
	var reward := String (data.get("reward", ""))
	tooltip_text = "%s\n\n%s\nRicompensa: %s" % [_title.text, how, reward]
	
	var icon_path := String(data.get("icon", ""))
	var tex: Texture2D = null
	if icon_path != "" and ResourceLoader.exists(icon_path):
		tex = load(icon_path)
	_icon.texture = tex
	
	modulate = Color(1,1,1,1) if _unlocked else Color (0.8,0.8,0.8,1)
	
func set_unlocked(value: bool) -> void:
	var _unlocked = value
	_lock.visible = not _unlocked
	modulate = Color(1,1,1,1) if _unlocked else Color (0.8,0.8,0.8,1)
