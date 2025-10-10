extends TextureRect

@export var image_paths: Array[String] = [
	"res://images/cuoreUI.png",
	"res://images/bellUI.png",
	"res://images/hashtagUI.png",
	"res://images/chatUI.png"
]

@export var spawn_interval: float = 1.0 # ogni quanti secondi spawna una nuova immagine
@export var upward_speed_range := Vector2(40, 100)
@export var amplitude_range := Vector2(20, 60)
@export var frequency_range := Vector2(1.0, 2.5)

var timer := 0.0
var screen_size := Vector2.ZERO
var active_bubbles: Array = []

# Ogni "bolla" sarà un piccolo dizionario con dati di movimento
# { node: TextureRect, base_x: float, speed_y: float, amplitude: float, frequency: float, time: float }

func _ready():
	screen_size = get_viewport_rect().size
	set_process(true)

func _process(delta):
	timer += delta
	if timer >= spawn_interval:
		timer = 0.0
		_spawn_image()

	# aggiorna movimento delle bolle
	for bubble in active_bubbles:
		bubble.time += delta
		var node : TextureRect = bubble.node
		node.position.y -= bubble.speed_y * delta
		node.position.x = bubble.base_x + sin(bubble.time * bubble.frequency) * bubble.amplitude

		# se la bolla è uscita dallo schermo, la rimuove
		if node.position.y < -node.size.y:
			node.queue_free()
			active_bubbles.erase(bubble)

func _spawn_image():
	# crea un nuovo TextureRect come figlio
	var img := TextureRect.new()
	img.texture = load(image_paths.pick_random())
	img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	img.size = Vector2(64, 64) # opzionale, puoi adattare alla tua immagine
	add_child(img)

	# parametri random
	var base_x = randf_range(0, screen_size.x - img.size.x)
	var start_y = screen_size.y + randf_range(0, 50)
	var speed_y = randf_range(upward_speed_range.x, upward_speed_range.y)
	var amplitude = randf_range(amplitude_range.x, amplitude_range.y)
	var frequency = randf_range(frequency_range.x, frequency_range.y)

	img.position = Vector2(base_x, start_y)

	# aggiunge la bolla alla lista
	active_bubbles.append({
		"node": img,
		"base_x": base_x,
		"speed_y": speed_y,
		"amplitude": amplitude,
		"frequency": frequency,
		"time": 0.0
	})
