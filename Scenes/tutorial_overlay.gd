extends Control
class_name TutorialOverlay

signal tutorial_finished

# Ogni slide: {
#   "title": String,
#   "text": String,
#   "target": Control,  # nodo da evidenziare (opzionale)
# }

@export var slides: Array[Dictionary] = []

var _current_index: int = 0

@onready var background: ColorRect = $Background
@onready var highlight: Panel = $Highlight
@onready var title_label: Label = $InfoPanel/Margin/VBox/TitleLabel
@onready var body_label: Label = $InfoPanel/Margin/VBox/BodyLabel
@onready var btn_prev: Button = $InfoPanel/Margin/VBox/Buttons/BtnPrev
@onready var btn_next: Button = $InfoPanel/Margin/VBox/Buttons/BtnNext
@onready var btn_skip: Button = $InfoPanel/Margin/VBox/Buttons/BtnSkip

func _ready() -> void:
	if slides.is_empty():
		return

	highlight.visible = true
	title_label.visible = true
	body_label.visible = true
	modulate.a = 1.0
	
	btn_prev.pressed.connect(_on_prev_pressed)
	btn_next.pressed.connect(_on_next_pressed)
	btn_skip.pressed.connect(_on_skip_pressed)

	_update_slide()

func start() -> void:
	if slides.is_empty():
		return

	btn_prev.pressed.connect(_on_prev_pressed)
	btn_next.pressed.connect(_on_next_pressed)
	btn_skip.pressed.connect(_on_skip_pressed)

	_update_slide()

func _update_slide() -> void:
	var slide := slides[_current_index]

	var t := String(slide.get("title", ""))
	var txt := String(slide.get("text", ""))

	title_label.text = t
	body_label.text = txt

	btn_prev.disabled = _current_index == 0

	# Gestione highlight
	if slide.has("target") and slide["target"] != null:
		var target: Control = slide["target"]
		if is_instance_valid(target):
			_show_highlight_on(target)
	else:
		# nessun target → spegni highlight
		highlight.visible = false

		# chiudi anche il “buco” dello shader
		var mat := background.material
		if mat:
			mat.set("shader_parameter/hole_uv_pos", Vector2.ZERO)
			mat.set("shader_parameter/hole_uv_size", Vector2.ZERO)





func _show_highlight_on(target: Control) -> void:
	highlight.visible = true

	var global_rect: Rect2 = target.get_global_rect()
	var to_local_xform: Transform2D = get_global_transform_with_canvas().affine_inverse()
	var local_pos: Vector2 = to_local_xform * global_rect.position

	highlight.position = local_pos
	highlight.size = global_rect.size

	# Aggiorna i parametri del buco nello shader del Background
	var overlay_size: Vector2 = get_rect().size
	if overlay_size.x <= 0.0 or overlay_size.y <= 0.0:
		return

	var hole_uv_pos := highlight.position / overlay_size
	var hole_uv_size := highlight.size / overlay_size

	var mat := background.material
	if mat:
		mat.set("shader_parameter/hole_uv_pos", hole_uv_pos)
		mat.set("shader_parameter/hole_uv_size", hole_uv_size)

func _on_prev_pressed() -> void:
	if _current_index > 0:
		_current_index -= 1
		_update_slide()


func _on_next_pressed() -> void:
	if _current_index < slides.size() - 1:
		_current_index += 1
		_update_slide()
	else:
		_finish_tutorial()


func _on_skip_pressed() -> void:
	_finish_tutorial()


func _finish_tutorial() -> void:
	emit_signal("tutorial_finished")
	queue_free()
