extends Window
signal avatar_selected(id: String)

@onready var grid: GridContainer= $MarginContainer/ScrollContainer/GridContainer

func ready():
	visible = false
	build_grid()

#costruisce la griglia degli avatar
func build_grid():
	if grid ==  null:
		push_error("GridContainer non trovato nel picker")
		return
	for child in grid.get_children():
		child.queue_free()
	for id in GameManager.avatars.keys():
		var info = GameManager.avatars[id]
		var btn := Button.new()
		btn.icon = GameManager.get_avatar_texture_thumb(id)
		btn.text = ""
		btn.custom_minimum_size = Vector2(48, 48)
		btn.disabled = not info.unlocked
		if btn.disabled:
			btn.modulate.a = 0.5
		btn.pressed.connect(func():
			avatar_selected.emit(id)
			hide()
		)
		grid.add_child(btn)
