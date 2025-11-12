extends CanvasLayer

func spawn_effect(texture: Texture2D, start_pos: Vector2) -> void:
	var icon = TextureRect.new()
	icon.texture = texture
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.size = Vector2(48, 48)
	icon.position = start_pos
	add_child(icon)

	# Animazione: sale verso l’alto e svanisce
	var tween = create_tween()
	tween.tween_property(icon, "position", start_pos + Vector2(0, -200), 1.2)
	tween.parallel().tween_property(icon, "modulate:a", 0.0, 1.2)
	tween.tween_callback(func(): icon.queue_free())
