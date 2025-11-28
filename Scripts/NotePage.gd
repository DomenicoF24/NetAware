extends Control

@export var line_color: Color = Color(0.75, 0.82, 0.9, 0.8)
@export var margin_color: Color = Color(0.9, 0.3, 0.3, 0.9)
@export var background_color: Color = Color(0.98, 0.97, 0.94, 1.0)
@export var line_spacing: int = 26
@export var margin_x: int = 40

func _ready() -> void:
	set_notify_transform(true)
	queue_redraw()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED or what == NOTIFICATION_TRANSFORM_CHANGED:
		queue_redraw()

func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, get_size())

	# sfondo carta
	draw_rect(rect, background_color, true)

	# righe orizzontali
	var y := line_spacing
	while y < rect.size.y:
		draw_line(
			Vector2(0, y),
			Vector2(rect.size.x, y),
			line_color,
			1.0
		)
		y += line_spacing

	# margine verticale stile quaderno
	draw_line(
		Vector2(margin_x, 0),
		Vector2(margin_x, rect.size.y),
		margin_color,
		2.0
	)
