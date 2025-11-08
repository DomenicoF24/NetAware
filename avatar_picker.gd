extends Control
signal avatar_selected(id: String)

@onready var grid:= %GridContainer

func ready():
	build_grid()

#costruisce la griglia degli avatar
func build_grid():
	grid.free_children()
	for id in GameManager.avatars.keys():
		var info = GameManager.avatars[id]
		var btn := TextureButton.new()
		btn.texture_normal = GameManager.get_avatar_texture_thumb(id)
		btn.tooltip_text = id
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		btn.disabled = not info.unlocked
		if btn.disabled:
			btn.modulate.a = 0.5
		btn.pressed.connect(func():
			avatar_selected.emit(id)
			hide()
		)
		grid.add_child(btn)
