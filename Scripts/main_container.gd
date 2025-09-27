extends HBoxContainer

@export var bg_color: Color = Color(1, 1, 1, 1.0)

func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), bg_color, true)

func _process(delta):
	queue_redraw() # ridisegna se la finestra cambia dimensione
