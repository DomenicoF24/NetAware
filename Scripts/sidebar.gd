extends VBoxContainer
@export var bg_color: Color = Color(0.8, 0.8, 0.8, 1.0)
@onready var btnHome = $Home

func _ready() -> void:
	_connect_button(btnHome, "_on_home_pressed")
	
	
func _connect_button(btn: Button, pressed_callback_name: String) -> void:
	btn.pressed.connect(Callable(self, pressed_callback_name))
	
func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")
	
func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), bg_color, true)

func _process(delta):
	queue_redraw() # forza il ridisegno
