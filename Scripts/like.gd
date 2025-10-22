extends TextureButton

var hover_scale := 1.1
var normal_scale := Vector2.ONE

func _ready():
	self.scale = normal_scale
	# Collego i segnali direttamente via codice
	self.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	self.connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _on_mouse_entered():
	var t = create_tween()
	t.tween_property(self, "scale", Vector2(hover_scale, hover_scale), 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_mouse_exited():
	var t = create_tween()
	t.tween_property(self, "scale", normal_scale, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
