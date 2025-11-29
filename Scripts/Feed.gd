extends Control

const TutorialOverlayScene := preload("res://Scenes/TutorialOverlay.tscn")

@onready var pb_sc = $MainContainer/Indicators/P1
@onready var pb_emp = $MainContainer/Indicators/P2
@onready var pb_priv = $MainContainer/Indicators/P3
@onready var pb_dep = $MainContainer/Indicators/P4
@onready var posts_container = $MainContainer/FeedColumn/PostsContainer
@onready var ideaButton = $MainContainer/Indicators/HBoxContainer5/IdeaButton 
@onready var feedback_label = $MainContainer/Indicators/HBoxContainer5/FeedbackLabel  # 👈 aggiunta Label
@onready var profile = $MainContainer/Sidebar/ProfileButton
@onready var messages = $MainContainer/Sidebar/Messaggi
@onready var appunti = $MainContainer/Sidebar/Appunti
@onready var NoteLog : PopupPanel = $NoteLog
@onready var messages_window: PopupPanel = $MessageWindow
@onready var toast: NewMessageToast = $NewMessageToast
@onready var indicators = $MainContainer/Indicators
@onready var gradient := ($Background.texture as GradientTexture2D).gradient
@onready var Feedback = $MainContainer/Indicators/HBoxContainer5
@onready var spir = $MainContainer/Indicators/HBoxContainer
@onready var emp = $MainContainer/Indicators/HBoxContainer2
@onready var pri = $MainContainer/Indicators/HBoxContainer3
@onready var dip = $MainContainer/Indicators/HBoxContainer4
@onready var btn_end_round: Button = $MainContainer/Indicators/endButton
@onready var round_popup: PanelContainer = $RoundSummaryPopup
@onready var lbl_round_title: Label = $RoundSummaryPopup/VBoxContainer/Label_title
@onready var lbl_round_body: Label = $RoundSummaryPopup/VBoxContainer/PanelContainer/MarginContainer/Label_body
@onready var stats_grid: GridContainer = $RoundSummaryPopup/VBoxContainer/PanelContainer/MarginContainer/StatsGrid
@onready var btn_round_notes: Button = $RoundSummaryPopup/VBoxContainer/HBoxContainer/Button_Notes
@onready var btn_round_new: Button = $RoundSummaryPopup/VBoxContainer/HBoxContainer/Button_NewRound

var post_scene = preload("res://Scenes/Post.tscn")
var tip_timer: Timer

var _queued_messages: Array[Dictionary] = []
var _scheduling_messages: bool = false

func _ready() -> void:
	# Connessione agli indicatori
	GameManager.connect("indicators_changed", _on_indicators_changed)
	_on_indicators_changed(
		GameManager.spirito_critico,
		GameManager.empatia,
		GameManager.privacy,
		GameManager.dipendenza
	)

	feedback_label.visible = true
	feedback_label.modulate.a = 1.0
	feedback_label.text = GameManager.get_tip("default")
	
	tip_timer = Timer.new()
	tip_timer.wait_time = 5.0
	tip_timer.one_shot = false
	tip_timer.autostart = true
	add_child(tip_timer)
	tip_timer.timeout.connect(_on_tip_timer_timeout)
	
	_apply_theme(GameManager.get_setting("theme", "light"))
	if not GameManager.theme_changed.is_connected(_on_theme_changed):
		GameManager.theme_changed.connect(_on_theme_changed)
	
	GameManager.reset_messages_for_session()
	_setup_messages_for_session()
	_start_message_schedule()

	# Notifica toast quando arriva un nuovo messaggio
	if not GameManager.message_added.is_connected(_on_message_added_for_toast):
		GameManager.message_added.connect(_on_message_added_for_toast)

	# Connessione al segnale educativo
	GameManager.connect("event_logged", _on_event_logged)

	# --- GESTIONE ROUND / RE-INGRESSO NEL FEED ---

	if not GameManager.round_has_started:
		# Primo ingresso nel feed: nuovo round (senza reset extra se già hai settato gli indicatori iniziali)
		_start_new_round(false)
	else:
		# Stai tornando nel feed con un round già in corso:
		# NON tocchiamo round_start_* in GameManager, rigeneriamo solo i post e riallineiamo la UI.
		_clear_feed_posts()
		spawn_random_posts(15)
		_on_indicators_changed(
			GameManager.spirito_critico,
			GameManager.empatia,
			GameManager.privacy,
			GameManager.dipendenza
		)
		if round_popup:
			round_popup.hide()

	# Tutorial dopo che il feed è pronto
	_show_tutorial_if_needed()
	
	if btn_end_round:
		btn_end_round.pressed.connect(_on_end_round_button_pressed)
		
	if round_popup:
		round_popup.hide()

	# connessioni bottoni popup
	if btn_round_notes and not btn_round_notes.pressed.is_connected(_on_round_notes_pressed):
		btn_round_notes.pressed.connect(_on_round_notes_pressed)

	if btn_round_new and not btn_round_new.pressed.is_connected(_on_round_new_round_pressed):
		btn_round_new.pressed.connect(_on_round_new_round_pressed)

	print("btn_round_notes =", btn_round_notes)
	print("btn_round_new =", btn_round_new)
	
	_connect_button(profile, "_on_profile_pressed")
	_connect_button(appunti, "_on_appunti_pressed")
	profile.text = GameManager.player_name
	if not GameManager.player_name_changed.is_connected(_on_player_name_changed):
		GameManager.player_name_changed.connect(_on_player_name_changed)
	
	_apply_avatar(GameManager.get_avatar_texture_full())
	if not GameManager.avatar_changed.is_connected(_on_avatar_changed):
		GameManager.avatar_changed.connect(_on_avatar_changed)

	if not Achievement.achievement_unlocked.is_connected(_on_achievement_unlocked):
		Achievement.achievement_unlocked.connect(_on_achievement_unlocked)
	
	_connect_button(messages, "_on_ButtonMessages_pressed")


func _connect_button(btn: Button, pressed_callback_name: String) -> void:
	btn.pressed.connect(Callable(self, pressed_callback_name))

func _on_profile_pressed():
	var profile_scene = preload("res://Scenes/ProfilePage.tscn")
	var profile2 = profile_scene.instantiate()
	profile2.return_to = 1

	var tree = get_tree()
	var old = tree.current_scene
	tree.root.add_child(profile2)
	tree.current_scene = profile2
	if old:
		old.queue_free()

func _on_ButtonMessages_pressed() -> void:
	if messages_window:
		messages_window.open_window()

func _on_appunti_pressed() -> void:
	if NoteLog:
		NoteLog.show()

func _on_theme_changed(theme: String) -> void:
	_apply_theme(theme)

func _apply_theme(theme: String) -> void:
	if theme == "dark":
		gradient.set_color(0, Color8(0x10, 0x10, 0x10)) # #101010
		gradient.set_color(1, Color8(0x18, 0x18, 0x18)) # #181818
		gradient.set_color(2, Color8(0x20, 0x20, 0x20)) # #202020
		gradient.set_color(3, Color8(0x28, 0x28, 0x28)) # #282828
	else:
		gradient.set_color(0, Color8(0xF5, 0x85, 0x29))
		gradient.set_color(1, Color8(0xDD, 0x2A, 0x7B))
		gradient.set_color(2, Color8(0x81, 0x34, 0xAF))
		gradient.set_color(3, Color8(0x51, 0x5B, 0xD4))

func _start_new_round(reset_stats: bool) -> void:
	# Chiedo al GameManager di iniziare un round.
	# Se reset_stats è true, resetta anche gli indicatori a 50/50/50/0.
	GameManager.begin_round(reset_stats)

	# Rigenera i post per il nuovo round
	_clear_feed_posts()
	spawn_random_posts(15)

	# Riallinea le progress bar ai valori attuali del GameManager
	_on_indicators_changed(
		GameManager.spirito_critico,
		GameManager.empatia,
		GameManager.privacy,
		GameManager.dipendenza
	)

	# Assicurati che il popup sia chiuso
	if round_popup:
		round_popup.visible = false

func _clear_feed_posts() -> void:
	for child in posts_container.get_children():
		child.queue_free()

func _on_end_round_button_pressed() -> void:
	round_popup.visible = true


	var delta_sc := GameManager.spirito_critico - GameManager.round_start_sc
	var delta_emp := GameManager.empatia         - GameManager.round_start_emp
	var delta_priv := GameManager.privacy        - GameManager.round_start_priv
	var delta_dep := GameManager.dipendenza      - GameManager.round_start_dep

	if lbl_round_title:
		lbl_round_title.text = "Riepilogo del round"

	if lbl_round_body:
		var body := ""

		# Blocco 1: variazioni
		body += "COME SONO CAMBIATE LE TUE COMPETENZE\n"
		body += "- Spirito critico: %+d\n" % int(delta_sc)
		body += "- Empatia:        %+d\n" % int(delta_emp)
		body += "- Privacy:        %+d\n" % int(delta_priv)
		body += "- Dipendenza:     %+d\n\n" % int(delta_dep)

		# Blocco 2: focus del round
		body += _build_round_focus_section(delta_sc, delta_emp, delta_priv, delta_dep)
		body += "\n"

		# Blocco 3: attenzione / consigli (con frasi random)
		body += _build_round_attention_section(delta_sc, delta_emp, delta_priv, delta_dep)

		lbl_round_body.text = body


func _build_round_focus_section(delta_sc: int, delta_emp: int, delta_priv: int, delta_dep: int) -> String:
	var focus_text := "QUESTO ROUND TI HA FATTO LAVORARE SOPRATTUTTO SU:\n"

	var max_delta : int = max(delta_sc, delta_emp, delta_priv)
	if max_delta <= 0:
		focus_text += "- Nessuna competenza in particolare: le variazioni sono state minime.\n"
		return focus_text

	if max_delta == delta_sc:
		focus_text += "- Spirito critico\n"
	elif max_delta == delta_emp:
		focus_text += "- Empatia digitale\n"
	else:
		focus_text += "- Protezione della privacy\n"

	return focus_text


func _build_round_attention_section(delta_sc: int, delta_emp: int, delta_priv: int, delta_dep: int) -> String:
	var txt := "CONSIDERAZIONE SULLE TUE AZIONI:\n"
	var has_warning := false

	# --- LISTE DI FRASI RANDOM ----

	var attention_dep_phrases := [
		"La tua dipendenza digitale è salita: prova a limitare le interazioni impulsive nei prossimi round.",
		"Hai interagito un po' troppo rapidamente: prenditi qualche secondo in più prima di scegliere.",
		"La dipendenza digitale sta aumentando. Fai attenzione ai contenuti che ti attirano senza motivo.",
		"Attenzione: molte interazioni sono state automatiche. Nel prossimo round prova a essere più selettivo.",
		"Il tempo speso sui contenuti rischiosi è stato elevato. Scegli con più calma.",
		"Stai sviluppando una tendenza all’uso compulsivo. Focalizzati solo sui post davvero rilevanti.",
		"In questo round alcuni contenuti hanno catturato troppo la tua attenzione. Mantieni il controllo.",
		"La crescita della dipendenza segnala interazioni ripetitive. Sperimenta azioni diverse.",
		"La dipendenza è aumentata: è un buon momento per rileggere gli appunti e comprendere i pattern.",
		"Stai cliccando troppo spesso senza valutare: cerca di bilanciare velocità e consapevolezza."
	]

	var attention_sc_phrases := [
		"Lo spirito critico è sceso: alcuni post ti hanno tratto in inganno.",
		"Hai reagito a contenuti fuorvianti: controlla le fonti con più attenzione.",
		"Attenzione: hai dato fiducia a post poco affidabili.",
		"Alcune decisioni sono state affrettate. Verifica meglio la credibilità del contenuto.",
		"Lo spirito critico ha avuto un calo. Nel prossimo round, osserva prima di cliccare.",
		"Alcuni post rischiosi non sono stati riconosciuti: rivedi gli indizi nei tuoi appunti.",
		"Sei stato un po’ impulsivo nel giudicare: prova a leggere con più calma.",
		"La valutazione dei contenuti non è stata precisa. Rallenta un secondo prima di reagire.",
		"Alcuni segnali di pericolo non sono stati notati: guarda meglio i dettagli grafici.",
		"Torna sui post in cui hai avuto un calo: ti aiuteranno a capire gli errori di percezione."
	]

	var attention_emp_phrases := [
		"L’empatia è diminuita: alcune risposte sono state un po’ troppo dirette.",
		"Hai interagito senza considerare come potevano sentirsi gli altri utenti.",
		"I commenti impulsivi hanno ridotto la tua empatia digitale.",
		"Attenzione: alcune reazioni sono state interpretate come poco sensibili.",
		"Un paio di scelte non hanno mostrato attenzione agli altri utenti.",
		"L'empatia è calata: fermati un attimo prima di commentare.",
		"Rilegge i post dove hai perso empatia: ti faranno capire come migliorare.",
		"Attento al tono: anche un piccolo errore può sembrare aggressivo.",
		"Hai sottovalutato il contesto emotivo di alcuni contenuti.",
		"Prova a immedesimarti un po’ di più negli altri nei prossimi round."
	]

	var attention_priv_phrases := [
		"La tua privacy ha subìto un calo: alcuni contenuti nascondevano rischi.",
		"Hai condiviso o accettato informazioni troppo sensibili.",
		"Alcuni link sospetti non sono stati riconosciuti. Presta più attenzione.",
		"Attenzione: hai sottovalutato contenuti che potevano esporre dati personali.",
		"La privacy è scesa: controlla meglio la credibilità delle fonti.",
		"Alcune interazioni rischiose hanno compromesso la sicurezza.",
		"Rivedi i post in cui hai perso privacy: c’erano segnali importanti da notare.",
		"Occhio alle richieste strane: non tutto è quello che sembra.",
		"Hai mostrato un po’ troppa fiducia in contenuti dubbi.",
		"La protezione dei dati è stata trascurata: fai più attenzione ai dettagli sospetti."
	]

	var attention_neutral_phrases := [
		"Non sono emerse criticità: hai mantenuto un buon equilibrio.",
		"Le tue scelte sono state costanti e ponderate.",
		"Nessun calo significativo: prosegui così.",
		"Il tuo comportamento digitale è stato stabile e consapevole.",
		"Hai gestito bene i contenuti senza errori evidenti.",
		"Buon round: hai mostrato attenzione nei punti chiave.",
		"Le tue valutazioni sono state equilibrate.",
		"Continua così: stai sviluppando buone abitudini digitali.",
		"Round pulito, senza particolari problemi.",
		"Hai mantenuto un comportamento maturo e responsabile."
	]

	# --- LOGICA DI SCELTA DELLE FRASI ----

	if delta_dep > 40:
		txt += "- " + attention_dep_phrases.pick_random() + "\n"
		has_warning = true

	if delta_sc < 0:
		txt += "- " + attention_sc_phrases.pick_random() + "\n"
		has_warning = true

	if delta_emp < 0:
		txt += "- " + attention_emp_phrases.pick_random() + "\n"
		has_warning = true

	if delta_priv < 0:
		txt += "- " + attention_priv_phrases.pick_random() + "\n"
		has_warning = true

	if not has_warning:
		txt += "- " + attention_neutral_phrases.pick_random() + "\n"

	return txt



func _on_round_notes_pressed() -> void:
# Apri gli appunti
	if NoteLog:
		NoteLog.show()

func _on_round_new_round_pressed() -> void:
	# Nuovo round *vero* → reset stats + nuovo round
	_start_new_round(true)
	
func _get_round_feedback_phrase(delta_sc: int, delta_emp: int, delta_priv: int, delta_dep: int) -> String:
	var positive_sum : int = max(delta_sc, 0) + max(delta_emp, 0) + max(delta_priv, 0)
	var negative_sum : int = max(-delta_sc, 0) + max(-delta_emp, 0) + max(-delta_priv, 0) + max(delta_dep, 0)

	if positive_sum == 0 and negative_sum == 0:
		return "In questo round hai avuto poche variazioni: prova a sperimentare di più con le tue scelte."

	if positive_sum > negative_sum * 2:
		return "Ottimo lavoro: in questo round le tue decisioni hanno rafforzato molto le tue competenze digitali."

	if delta_dep > 0 and positive_sum <= negative_sum:
		return "Attenzione: la tua dipendenza digitale è cresciuta più dei benefici ottenuti. Riguarda gli appunti e valuta dove hai esagerato."

	if negative_sum > positive_sum:
		return "Hai commesso diversi errori: usa gli appunti per capire quali scelte hanno abbassato le tue competenze."

	return "Hai fatto sia scelte buone che qualche errore: riflettere su questo round ti aiuterà a migliorare nei prossimi."


func _apply_avatar(tex: Texture2D):
	if not tex: return
	if profile is TextureRect:
		profile.texture = tex
	elif profile is Button:
		profile.icon = tex
func _on_player_name_changed(new_name: String):
	profile.text = new_name

func _on_indicators_changed(sc: int, emp: int, priv: int, dep: int) -> void:
	animate_progressbar(pb_sc, sc)
	animate_progressbar(pb_emp, emp)
	animate_progressbar(pb_priv, priv)
	animate_progressbar(pb_dep, dep)

func animate_progressbar(pb: ProgressBar, new_value: int) -> void:
	var tween = create_tween()
	tween.tween_property(pb, "value", new_value, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

var tip_queue: Array[String] = []


func _on_event_logged(text: String) -> void:
	tip_queue.append(text)

func _on_tip_timer_timeout() -> void:
	var next_text: String
	if tip_queue.size() > 0:
		next_text = tip_queue.pop_front()
	else:
		# nessun evento recente: mostra un suggerimento casuale
		next_text = GameManager.get_tip("default")

	feedback_label.text = next_text
	feedback_label.modulate.a = 1.0
	
func _start_message_schedule() -> void:
	if _scheduling_messages:
		return
	_scheduling_messages = true
	call_deferred("_schedule_messages_loop")  # parte dopo che la scena è pronta

func _schedule_messages_loop() -> void:
	while not _queued_messages.is_empty():
		var next: Dictionary = _queued_messages[0]
		_queued_messages.remove_at(0)

		var delay: float = float(next.get("delay", 60.0))
		var id: String = String(next.get("id", ""))

		if id == "":
			continue

		# attesa non bloccante
		await get_tree().create_timer(delay).timeout

		# potrebbe succedere che il feed sia stato cambiato/chiuso, controlla un minimo
		if not is_inside_tree():
			return

		GameManager.add_message(id)

	_scheduling_messages = false

func _setup_messages_for_session() -> void:
	# Pulisci la coda precedente
	_queued_messages.clear()

	# Quanti messaggi usare in questa sessione
	var total_messages: int = 5
	var immediate_count: int = 2

	# Ottieni ID casuali dal GameManager
	var session_ids: Array[String] = GameManager.get_random_message_ids(total_messages)

	# --- RNG per i delay casuali ---
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	# --- Messaggi immediati (spawnati subito) ---
	var index: int = 0
	while index < session_ids.size() and index < immediate_count:
		var id: String = session_ids[index]
		GameManager.add_message(id)  # resa immediata
		index += 1

	# --- Messaggi ritardati ---
	var remaining_index: int = index
	while remaining_index < session_ids.size():
		var id2: String = session_ids[remaining_index]

		# Delay completamente random tra 45s e 150s
		var delay: float = rng.randf_range(45.0, 150.0)

		var entry: Dictionary = {
			"id": id2,
			"delay": delay
		}

		_queued_messages.append(entry)
		remaining_index += 1

func _on_message_added_for_toast(id: String) -> void:
	var data: Dictionary = GameManager.get_message_data(id)
	var msg: String = "Hai ricevuto un nuovo messaggio!"
	toast.show_toast(msg)

func spawn_random_posts(count: int = 5) -> void:
	# Creiamo una copia dei template disponibili
	var available_posts = post_templates.duplicate()
	
	for i in range(count):
		if available_posts.is_empty():
			break  # Non ci sono più post da spawnare

		# Scegliamo un post casuale dalla lista disponibile
		var index = randi() % available_posts.size()
		var template = available_posts[index]
		
		# Istanzio il post e lo aggiungo al container
		var p = post_scene.instantiate()
		posts_container.add_child(p)
		p.set_post_data(template)
		
		# Rimuovo il template appena usato per evitare duplicati
		available_posts.remove_at(index)
		
func _on_avatar_changed(tex: Texture2D, _id: String):
	_apply_avatar(tex)

func _on_achievement_unlocked(id: String) -> void:
	var data := Achievement.get_data(id)
	if data.is_empty():
		return

	var name := String(data.get("name", id))
	var icon_path := String(data.get("icon", ""))
	var tex: Texture2D = null
	if icon_path != "" and ResourceLoader.exists(icon_path):
		tex = load(icon_path)

	var popup := get_tree().get_first_node_in_group("achievement_popup")
	if popup:
		if popup.has_method("show_achievement_id"):
			popup.show_achievement_id(id, name, tex)
		elif popup.has_method("show_achievement"):
			popup.show_achievement("Hai sbloccato: %s" % name, tex)

func _show_tutorial_if_needed() -> void:
# Se l'utente arriva dal bottone Tutorial, forziamo il tutorial
	if not GameManager.force_feed_tutorial_once and GameManager.has_seen_feed_tutorial:
		return

	# Qualsiasi sia il caso, consumiamo il "force" (vale solo una volta)
	GameManager.force_feed_tutorial_once = false
	
	var example_post: PostCard = null
	var targets: Dictionary = {}

	if posts_container.get_child_count() > 0:
		example_post = posts_container.get_child(0) as PostCard
		if example_post:
			targets = example_post.get_tutorial_targets()

	var overlay: TutorialOverlay = TutorialOverlayScene.instantiate()

	overlay.slides = [
		{
			"title": "BENVENUTO IN NETAWARE",
			"text": "Questo tutorial ti guiderà attraverso le funzioni principali del gioco. Imparerai a leggere i post, valutare i contenuti e capire come le tue azioni influenzano i tuoi indicatori digitali. Prenditi un momento per orientarti prima di iniziare.",
			"target": null
		},
		{
			"title": "IL FEED",
			"text": "Qui vedi i post del social fittizio. Alcuni sono sicuri, altri possono nascondere rischi. Interagisci con i post: valuta cosa faresti, segnala i contenuti problematici e fai scelte consapevoli. Ogni volta che premi il tasto 'GIOCA' i post cambiano.",
			"target": posts_container
		},
		{
			"title": "IL POST",
			"text": "Hai molte cose a cui fare attenzione.",
			"target": targets.get("Post", posts_container)
		},
		{
			"title": "INFO PRINCIPALI",
			"text": "Controlla con attenzione il nome, il verificato può aiutarti molto a decifrare se il post è rischioso o meno.",
			"target": targets.get("top", posts_container)
		},
		{
			"title": "LIKE",
			"text": "Il numero dei like ti dice molto: se il numero è basso potrebbe essere un post pericoloso, se è alto potrebbe essere una fonte sicura, ma fai comunque attenzione a tutti i dettagli.",
			"target": targets.get("like", posts_container)
		},
		{
			"title": "DIDASCALIA",
			"text": "Le parole usate nella didascalia sono una fonte molto attendibile dell'affidabilità del post. Scegli come interagire con il post tramite i bottoni 'like, commenta, segnala, condividi', ogni tua azione si ripercuoterà sulle statistiche.",
			"target": targets.get("comments", posts_container)
		},
		{
			"title": "ATTENTO AI MESSAGGI",
			"text": "Qui vedi i messaggi che ti arrivano, scegli di ignorare, rispondere o segnalare. Le tue azioni avranno delle conseguenze.",
			"target": messages
		},
				{
			"title": "PRENDI NOTA",
			"text": "Qui avrai contrassegnate tutte le azioni eseguite durante il periodo di gioco. Le informazioni sono nel formato '#post, azione eseguita, corretto/errore, impatto sui progressi'. Avrai modo di riflettere sulle tue azioni, in maniera tale da imparare dai tuoi errori e non commetterli di nuovo.",
			"target": appunti
		},
		{
			"title": "PROFILO E ACHIEVEMENT",
			"text": "Nel profilo puoi modificare il tuo avatar, controllare la barra di esperienza ed il tempo di gioco e cosa più importante vedere gli achievement sbloccati, completali tutti e diventa il re dei social.",
			"target": profile
		},
		{
			"title": "LE TUE COMPETENZE DIGITALI",
			"text": "Questa barra mostra gli INDICATORI DI CONSAPEVOLEZZA. Le tue scelte faranno salire o scendere questi valori. Quando raggiungi un obiettivo comparirà un popup a schermo, ogni obiettivo ti fornirà delle ricompense.",
			"target": indicators
		},
		{
			"title": "SPIRITO CRITICO",
			"text": "Lo spirito critico rappresenta la tua capacità di analizzare le informazioni prima di reagire. Aumenta quando valuti correttamente un post e riconosci contenuti fuorvianti o rischiosi; diminuisce quando agisci impulsivamente senza verificare fonti, contesto o credibilità.",
			"target": spir
		},
		{
			"title": "EMPATIA",
			"text": "L’empatia indica quanto riesci a metterti nei panni degli altri nelle interazioni digitali. Sale quando scegli comportamenti rispettosi.",
			"target": emp
		},
		{
			"title": "PRIVACY",
			"text": "La privacy misura quanto proteggi le tue informazioni e quanto riconosci rischi legati alla condivisione online. Cresce quando interagisci con post riguardanti la sicurezza e condividi le informazioni agli altri; cala quando condividi o accetti contenuti che espongono la tua identità o informazioni sensibili.",
			"target": pri
		},
		{
			"title": "DIPENDENZA",
			"text": "La dipendenza digitale riflette quanto sei capace di gestire il tempo online e l'uso delle piattaforme social. Aumenta automaticamente col passare del tempo.",
			"target": dip
		},
		{
			"title": "CONSIGLI UTILI",
			"text": "Questa sezione ti fornisce consigli utili, buttaci un occhio ogni tanto.",
			"target": Feedback
		},
		{
			"title": "CONCLUDI IL ROUND",
			"text": "Premendo questo bottone concluderai il round. Ti verrà mostrata una pagina di riepilogo con le azioni compiute nel round e potrai iniziarne un altro.",
			"target": btn_end_round
		},
		{
			"title": "SEI PRONTO!",
			"text": "Ora esplora il feed. Puoi rivedere questo tutorial in qualsiasi momento dal menu iniziale.",
			"target": null
		}
	]
	add_child(overlay)
	
	overlay.tutorial_finished.connect(_on_feed_tutorial_finished)

func _on_feed_tutorial_finished() -> void:
	GameManager.has_seen_feed_tutorial = true
	GameManager.save_profile()

var post_templates = [
	{
		"pic": preload("res://images/man3.png"),
		"author": "@Marco98",
		"content": "Ho trovato questa foto online di New York... ma sarà vera?",
		"time": "2 ore fa",
		"foto": preload("res://images/NY.jpg"),
		"likes": "Piace a 12 persone",
		"effects_like": {"sc": -10},
		"effects_report": {"sc": +10},
		"effects_share": {"sc": -10, "dep": +10},
		"effects_comment": {"emp": +5},
		"dangerous": true,
		"category": "fake_news",
		"verified": false
	},
	{
		"pic": preload("res://images/robot.png"),
		"author": "@NewsBot",
		"content": "Ricorda: non condividere le tue password con nessuno!",
		"time": "5 ore fa",
		"foto": preload("res://images/lock.jpg"),
		"likes": "Piace a 3mila persone",
		"effects_like": {"sc": 5, "priv": +10},
		"effects_report": {"sc": -15},
		"effects_share": {"sc": +15, "dep": +5},
		"effects_comment": {"emp": +5},
		"dangerous": false,
		"category": "privacy_advice",
		"verified": true
	},
	{
		"pic": preload("res://images/man1.png"),
		"author": "@InfluencerX",
		"content": "Questo sito funziona al 100%, fidatevi! http://VrsMn.com",
		"time": "30 minuti fa",
		"foto": preload("res://images/soldi.png"),
		"likes": "Piace a 100 persone",
		"effects_like": {"sc": -10},
		"effects_report": {"sc": +15},
		"effects_share": {"sc": -10, "dep": +5},
		"effects_comment": {"emp": -5},
		"dangerous": true,
		"category": "fraud",
		"verified": false
	},
	{
		"pic": preload("res://images/man2.png"),
		"author": "@Luc1a_",
		"content": "Guardate che foto simpatica!",
		"time": "23 ore fa",
		"foto": preload("res://images/cat.jpg"),
		"likes": "Piace a 142 persone",
		"effects_like": {"emp": +5},
		"effects_report": {"sc": -10},
		"effects_share": {"dep": +5},
		"effects_comment": {"emp": +10},
		"dangerous": false,
		"category": "default",
		"verified": false
	},
		{
		"pic": preload("res://images/Netw.png"),
		"author": "@NetAware",
		"content": "Se ti stai divertendo lascia un like al post",
		"time": "10 ore fa",
		"foto": preload("res://images/Netw.jpg"),
		"likes": "Piace a 13mila persone",
		"effects_like": {"emp": +20},
		"effects_report": {"sc": -10},
		"effects_share": {"dep": +5},
		"effects_comment": {},
		"dangerous": false,
		"category": "default",
		"verified": true
	},
		{
		"pic": preload("res://images/news64.png"),
		"author": "@NetNews",
		"content": "Ultim'ora! L'AI si impossessa dei giornali!",
		"time": "2 minuti fa",
		"foto": preload("res://images/news.jpg"),
		"likes": "Piace a 80 persone",
		"effects_like": {"emp": +5},
		"effects_report": {"sc": -5},
		"effects_share": {"dep": +5},
		"effects_comment": {"emp": +5},
		"dangerous": false,
		"category": "default",
		"verified": false
	},
	
		{
		"pic": preload("res://images/goal64.png"),
		"author": "@Football_24h",
		"content": "Finisce 1-0 la partita di oggi!",
		"time": "5 minuti fa",
		"foto": preload("res://images/calcio.jpeg"),
		"likes": "Piace a 4mila persone",
		"effects_like": {"emp": +10},
		"effects_report": {"sc": -10},
		"effects_share": {"dep": +5},
		"effects_comment": {"emp": +10},
		"dangerous": false,
		"category": "default",
		"verified": true
	},
	
		{
		"pic": preload("res://images/gym64.png"),
		"author": "@GymTraining",
		"content": "Iscriviti alla nostra palestra, chiama subito!",
		"time": "20 ore fa",
		"foto": preload("res://images/gym.jpg"),
		"likes": "Piace a 250 persone",
		"effects_like": {"emp": +5},
		"effects_report": {"sc": -10},
		"effects_share": {"dep": +5},
		"effects_comment": {"emp": +5},
		"dangerous": false,
		"category": "default",
		"verified": false
	},
		{
		"pic": preload("res://images/game64.png"),
		"author": "@GameDev011",
		"content": "Scarica subito il nostro NUOVISSIMO gioco! https://Vrs.Ga",
		"time": "12 ore fa",
		"foto": preload("res://images/game.jpg"),
		"likes": "Piace a 64 persone",
		"effects_like": {},
		"effects_report": {"sc": +15},
		"effects_share": {"dep": +5, "sc": -10},
		"effects_comment": {"emp": +5},
		"dangerous": true,
		"category": "fraud",
		"verified": false
	},
			{
		"pic": preload("res://images/robot.png"),
		"author": "@NewsBot",
		"content": "Verifica sempre le fonti dei post",
		"time": "51 minuti fa",
		"foto": preload("res://images/bot2.jpg"),
		"likes": "Piace a 700 persone",
		"effects_like": {"emp": +5, "priv": +10},
		"effects_report": {"sc": -15},
		"effects_share": {"dep": +5, "sc": +5},
		"effects_comment": {"emp": +5},
		"dangerous": false,
		"category": "privacy_advice",
		"verified": true
	},
			{
		"pic": preload("res://images/news64.png"),
		"author": "@NetNews",
		"content": "Proteste di oggi per il diritto allo studio",
		"time": "2 minuti fa",
		"foto": preload("res://images/proteste.jpeg"),
		"likes": "Piace a 300 persone",
		"effects_like": {"emp": +5},
		"effects_report": {"sc": +10},
		"effects_share": {"dep": +5, "sc": -15},
		"effects_comment": {"sc": -5},
		"dangerous": true,
		"category": "fake_news",
		"verified": false
	},
	{
		"pic": preload("res://images/woman1.png"),
		"author": "@Anna23",
		"content": "Condividi la tua password con un amico fidato? Meglio di no!",
		"time": "1 ora fa",
		"foto": preload("res://images/password.jpg"),
		"likes": "Piace a 200 persone",
		"effects_like": {"sc": +5, "priv": +5},
		"effects_report": {"sc": -5},
		"effects_share": {"sc": +5, "emp": +5},
		"effects_comment": {"emp": +2},
		"dangerous": false,
		"category": "privacy_advice",
		"verified": true
	},
	{
		"pic": preload("res://images/man4.png"),
		"author": "@Luca99",
		"content": "Hai vinto un iPhone gratis! Clicca qui subito!",
		"time": "30 min fa",
		"foto": preload("res://images/iphone.jpg"),
		"likes": "Piace a 3 persone",
		"effects_like": {"sc": -15, "dep": +5},
		"effects_report": {"sc": +15},
		"effects_share": {"sc": -20, "dep": +10},
		"effects_comment": {"emp": +1},
		"dangerous": true,
		"category": "fraud",
		"verified": false
	},
	{
		"pic": preload("res://images/woman2.png"),
		"author": "@GiuliaX",
		"content": "Ecco 5 modi per proteggere la tua privacy online.",
		"time": "5 ore fa",
		"foto": preload("res://images/privacy.jpg"),
		"likes": "Piace a 311 persone",
		"effects_like": {"sc": +5, "priv": +10},
		"effects_report": {"sc": 0},
		"effects_share": {"sc": +2, "emp": +2},
		"effects_comment": {"emp": +3},
		"dangerous": false,
		"category": "privacy_advice",
		"verified": true
	},
	{
		"pic": preload("res://images/man5.png"),
		"author": "@HalfTech",
		"content": "Questo prodotto funziona al 100%! Fidatevi!",
		"time": "20 min fa",
		"foto": preload("res://images/clean.jpg"),
		"likes": "Piace a 40 persone",
		"effects_like": {"sc": -5, "dep": +5},
		"effects_report": {"sc": +5},
		"effects_share": {"sc": -5, "dep": +5},
		"effects_comment": {"emp": +1},
		"dangerous": true,
		"category": "fake_news",
		"verified": false
	},
	{
		"pic": preload("res://images/woman3.png"),
		"author": "@Elisa07",
		"content": "Non cliccare su link sospetti ricevuti in chat, potresti essere truffato!",
		"time": "10 min fa",
		"foto": preload("res://images/click.jpg"),
		"likes": "Piace a 209 persone",
		"effects_like": {"sc": +5, "priv": +5},
		"effects_report": {"sc": +10},
		"effects_share": {"sc": -5},
		"effects_comment": {"emp": +2},
		"dangerous": true,
		"category": "fraud",
		"verified": true
	}
	
]
