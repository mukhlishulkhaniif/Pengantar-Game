extends Control

const MAIN_MENU_SCENE: String = "res://scenes/main_menu.tscn"
const ArenaViewScript = preload("res://scripts/presentation/arena_view.gd")
const QuestionGenerator = preload("res://scripts/domain/question_generator.gd")
const WAVE_COUNTS: Array[int] = [4, 5, 6]
const GUARDIAN_COSTS: Dictionary = {"Plusy": 35, "Addy Cannon": 70, "Shield Cube": 50, "Multiply Dragon": 95, "Fraction Fairy": 85, "Number Knight": 85}
const QUESTION_COOLDOWN_SECONDS: float = 18.0
const GUARDIAN_PLACEMENT_COOLDOWNS: Dictionary = {
	"Plusy": 5.0,
	"Addy Cannon": 7.0,
	"Shield Cube": 8.0,
	"Multiply Dragon": 10.0,
	"Fraction Fairy": 10.0,
	"Number Knight": 9.0
}

var energy: int = 180
var core_hp: int = 120
var combo: int = 0
var score: int = 0
var defeated_enemies: int = 0
var total_questions: int = 0
var correct_answers: int = 0
var wrong_answers: int = 0
var answer_history: Array[Dictionary] = []
var current_wave: int = 0
var spawned_this_wave: int = 0
var spawn_target: int = 0
var spawn_timer: float = 0.0
var passive_energy_timer: float = 0.0
var question_cooldown_timer: float = 0.0
var guardian_placement_cooldowns: Dictionary = {
	"Plusy": 0.0,
	"Addy Cannon": 0.0,
	"Shield Cube": 0.0,
	"Multiply Dragon": 0.0,
	"Fraction Fairy": 0.0,
	"Number Knight": 0.0
}
var intermission_timer: float = 0.0
var next_enemy_id: int = 1
var last_spawned_lane: int = -1
var battle_finished: bool = false
var paused: bool = false
var selected_guardian: String = ""
var drag_candidate_type: String = ""
var drag_start_position: Vector2 = Vector2.ZERO
var drag_active: bool = false
var guardians: Array = []
var enemies: Array = []
var projectiles: Array = []
var current_question: Dictionary = {}
var arena
var energy_button: Button
var energy_cooldown_overlay: ColorRect
var energy_cooldown_bar: ProgressBar
var guardian_cooldown_overlays: Array[ColorRect] = []
var guardian_cooldown_bars: Array[ProgressBar] = []
var core_label: Label
var wave_label: Label
var score_label: Label
var wave_progress_label: Label
var core_bar: ProgressBar
var energy_bar: ProgressBar
var question_label: Label
var math_heading: Label
var reward_hint_label: Label
var feedback_label: Label
var pause_button: Button
var answer_buttons: Array[Button] = []
var wave_segments: Array[PanelContainer] = []
var wave_banner: Control
var wave_banner_timer: float = 0.0
var last_wave_segment_state: int = -1
var question_popup: Control
var question_popup_open: bool = false
var question_result_showing: bool = false
var question_is_wave_challenge: bool = false
var wave_question_pending: bool = false
var bonus_question_used_this_wave: bool = false
var guardian_buttons: Array[Button] = []
var guardian_button_types: Array[String] = ["Plusy", "Addy Cannon", "Shield Cube", "Multiply Dragon", "Fraction Fairy", "Number Knight"]

func _ready() -> void:
	randomize()
	_build_ui()
	_start_next_wave()
	_refresh_hud()

func _process(delta: float) -> void:
	_update_wave_banner(delta)

	# Soal tidak muncul otomatis setelah banner. Pemain membuka soal sendiri
	# lewat tombol energi ketika merasa membutuhkan tambahan energi.
	if battle_finished or paused:
		return

	if question_cooldown_timer > 0.0:
		var old_question_cooldown: float = question_cooldown_timer
		question_cooldown_timer = maxf(0.0, question_cooldown_timer - delta)
		if old_question_cooldown > 0.0 and question_cooldown_timer <= 0.0:
			_pulse_ready_button(energy_button)

	for guardian_type in guardian_button_types:
		var old_guardian_cooldown: float = float(guardian_placement_cooldowns.get(guardian_type, 0.0))
		if old_guardian_cooldown > 0.0:
			var new_guardian_cooldown: float = maxf(0.0, old_guardian_cooldown - delta)
			guardian_placement_cooldowns[guardian_type] = new_guardian_cooldown
			if new_guardian_cooldown <= 0.0:
				_pulse_ready_button(_get_guardian_button(guardian_type))

	# Regenerasi pasif dibuat kecil agar keputusan penempatan Guardian tetap penting.
	passive_energy_timer += delta
	if passive_energy_timer >= 12.0:
		passive_energy_timer -= 12.0
		energy = mini(999, energy + 3)
		if is_instance_valid(arena):
			arena.add_visual_effect("reward", Vector2(arena.size.x * 0.5, 44.0), Color("#a6e6b8"), "+3 ENERGI")

	if spawned_this_wave < spawn_target:
		spawn_timer += delta
		# Ritme lebih lambat: beri waktu untuk membaca soal dan menyusun pertahanan.
		var spawn_interval: float = maxf(5.5, 6.5 - float(current_wave - 1) * 0.5)
		if spawn_timer >= spawn_interval:
			spawn_timer = 0.0
			_spawn_enemy()

	_update_guardians(delta)
	_update_projectiles(delta)
	_update_enemies(delta)
	if battle_finished:
		return

	if spawned_this_wave >= spawn_target and enemies.is_empty() and projectiles.is_empty():
		if current_wave < WAVE_COUNTS.size():
			intermission_timer += delta
			if intermission_timer >= 3.2:
				_start_next_wave()
		else:
			_finish_battle(true)

	_refresh_hud()

func _make_cooldown_overlay(parent_button: Button) -> ColorRect:
	var overlay := ColorRect.new()
	overlay.color = Color(0.035, 0.045, 0.035, 0.48)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.visible = false
	parent_button.add_child(overlay)
	return overlay

func _make_cooldown_bar(parent_button: Button) -> ProgressBar:
	var bar := ProgressBar.new()
	bar.min_value = 0.0
	bar.max_value = 100.0
	bar.value = 0.0
	bar.show_percentage = false
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.anchor_left = 0.0
	bar.anchor_top = 1.0
	bar.anchor_right = 1.0
	bar.anchor_bottom = 1.0
	bar.offset_left = 5.0
	bar.offset_top = -10.0
	bar.offset_right = -5.0
	bar.offset_bottom = -4.0
	bar.visible = false
	var background_style := StyleBoxFlat.new()
	background_style.bg_color = Color("#1b2118")
	background_style.set_corner_radius_all(2)
	bar.add_theme_stylebox_override("background", background_style)
	var fill_style := StyleBoxFlat.new()
	fill_style.bg_color = Color("#d9b75f")
	fill_style.set_corner_radius_all(2)
	bar.add_theme_stylebox_override("fill", fill_style)
	parent_button.add_child(bar)
	return bar

func _get_guardian_button(guardian_type: String) -> Button:
	var button_index: int = guardian_button_types.find(guardian_type)
	if button_index >= 0 and button_index < guardian_buttons.size():
		return guardian_buttons[button_index]
	return null

func _pulse_ready_button(button: Button) -> void:
	if not is_instance_valid(button) or paused or battle_finished:
		return
	button.modulate = Color(1.22, 1.13, 0.78, 1.0)
	var ready_tween := create_tween()
	ready_tween.tween_property(button, "modulate", Color.WHITE, 0.32)

func _update_cooldown_visuals() -> void:
	if is_instance_valid(energy_button):
		var question_cooling: bool = question_cooldown_timer > 0.0
		energy_button.disabled = paused or battle_finished or question_cooling
		if is_instance_valid(energy_cooldown_overlay):
			energy_cooldown_overlay.visible = question_cooling
		if is_instance_valid(energy_cooldown_bar):
			energy_cooldown_bar.visible = question_cooling
			energy_cooldown_bar.value = (QUESTION_COOLDOWN_SECONDS - question_cooldown_timer) / QUESTION_COOLDOWN_SECONDS * 100.0
		if question_cooling:
			energy_button.tooltip_text = "Soal tersedia dalam %d detik" % ceili(question_cooldown_timer)
		else:
			energy_button.tooltip_text = "Ketuk untuk membuka soal matematika dan mendapat energi"

	for index in range(guardian_buttons.size()):
		var guardian_type: String = guardian_button_types[index]
		var cooldown_max: float = float(GUARDIAN_PLACEMENT_COOLDOWNS.get(guardian_type, 0.0))
		var remaining: float = float(guardian_placement_cooldowns.get(guardian_type, 0.0))
		var cooling: bool = remaining > 0.0
		if index < guardian_cooldown_overlays.size():
			guardian_cooldown_overlays[index].visible = cooling
		if index < guardian_cooldown_bars.size():
			guardian_cooldown_bars[index].visible = cooling
			var elapsed: float = cooldown_max - remaining
			guardian_cooldown_bars[index].value = clampf(elapsed / maxf(cooldown_max, 0.001) * 100.0, 0.0, 100.0)

func _build_ui() -> void:
	# UI berpalet vintage: kertas krem, tinta gelap, hijau hutan, dan emas antik.
	var background := ColorRect.new()
	background.color = Color("#d8c9a8")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_top", 7)
	margin.add_theme_constant_override("margin_bottom", 7)
	add_child(margin)

	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 6)
	outer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(outer)

	# Seed bank ringkas, dengan energi sebagai tombol untuk membuka tantangan matematika.
	var header_panel := PanelContainer.new()
	header_panel.custom_minimum_size = Vector2(0, 84)
	header_panel.add_theme_stylebox_override("panel", _panel_style(Color("#243a29"), Color("#171a13"), 5, 5))
	outer.add_child(header_panel)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 4)
	header.alignment = BoxContainer.ALIGNMENT_CENTER
	header_panel.add_child(header)

	# HUD landscape: energi, enam kartu, tracker wave visual, dan tombol aksi.
	var viewport_width: float = maxf(get_viewport_rect().size.x, 800.0)
	var card_width: float = clampf(viewport_width * 0.066, 78.0, 98.0)
	var energy_width: float = clampf(viewport_width * 0.082, 96.0, 116.0)

	energy_button = _make_button("✦ %d" % energy, Vector2(energy_width, 72), true)
	energy_button.add_theme_font_size_override("font_size", 21)
	energy_button.tooltip_text = "Buka soal matematika secara manual untuk mendapat energi"
	energy_button.pressed.connect(_open_question_popup)
	energy_cooldown_overlay = _make_cooldown_overlay(energy_button)
	energy_cooldown_bar = _make_cooldown_bar(energy_button)
	header.add_child(energy_button)

	var seed_separator := VSeparator.new()
	seed_separator.add_theme_color_override("color", Color("#bba87a"))
	header.add_child(seed_separator)

	guardian_button_types = ["Plusy", "Addy Cannon", "Shield Cube", "Multiply Dragon", "Fraction Fairy", "Number Knight"]
	var card_titles: Dictionary = {
		"Plusy": "PLUSY\n35",
		"Addy Cannon": "ADDY\n70",
		"Shield Cube": "SHIELD\n50",
		"Multiply Dragon": "DRAGON\n95",
		"Fraction Fairy": "FAIRY\n85",
		"Number Knight": "KNIGHT\n85"
	}
	for guardian_type in guardian_button_types:
		var guardian_button := _make_button(str(card_titles[guardian_type]), Vector2(card_width, 72), false)
		guardian_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		guardian_button.add_theme_font_size_override("font_size", 12 if card_width < 90.0 else 13)
		guardian_button.tooltip_text = "%s • %d energi" % [guardian_type, int(GUARDIAN_COSTS.get(guardian_type, 0))]
		guardian_button.pressed.connect(_select_guardian.bind(guardian_type))
		var cooldown_overlay: ColorRect = _make_cooldown_overlay(guardian_button)
		var cooldown_bar: ProgressBar = _make_cooldown_bar(guardian_button)
		guardian_buttons.append(guardian_button)
		guardian_cooldown_overlays.append(cooldown_overlay)
		guardian_cooldown_bars.append(cooldown_bar)
		header.add_child(guardian_button)

	# Tracker wave mengisi ruang tengah secara sengaja, bukan menyisakan celah kosong.
	var status_panel := PanelContainer.new()
	status_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	status_panel.custom_minimum_size = Vector2(185, 0)
	status_panel.add_theme_stylebox_override("panel", _panel_style(Color("#1c3022"), Color("#63734a"), 7, 7))
	header.add_child(status_panel)
	var status := VBoxContainer.new()
	status.add_theme_constant_override("separation", 4)
	status_panel.add_child(status)
	var status_top := HBoxContainer.new()
	status_top.add_theme_constant_override("separation", 6)
	status.add_child(status_top)
	wave_label = _make_label("WAVE 1", 14, Color("#f4e8c9"))
	wave_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	status_top.add_child(wave_label)
	wave_progress_label = _make_label("0/4", 11, Color("#d7c9a8"), HORIZONTAL_ALIGNMENT_CENTER)
	status_top.add_child(wave_progress_label)
	core_label = _make_label("♥ 120", 13, Color("#f2c2a8"), HORIZONTAL_ALIGNMENT_RIGHT)
	status_top.add_child(core_label)

	var wave_track := HBoxContainer.new()
	wave_track.add_theme_constant_override("separation", 4)
	wave_track.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	status.add_child(wave_track)
	wave_segments.clear()
	for i in range(3):
		var segment := PanelContainer.new()
		segment.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		segment.custom_minimum_size = Vector2(0, 7)
		segment.add_theme_stylebox_override("panel", _panel_style(Color("#53634a"), Color("#53634a"), 3, 0))
		wave_segments.append(segment)
		wave_track.add_child(segment)

	core_bar = ProgressBar.new()
	core_bar.min_value = 0.0
	core_bar.max_value = 120.0
	core_bar.value = core_hp
	core_bar.show_percentage = false
	core_bar.custom_minimum_size = Vector2(0, 9)
	core_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	core_bar.add_theme_stylebox_override("background", _meter_style(Color("#171a13")))
	core_bar.add_theme_stylebox_override("fill", _meter_style(Color("#b95c49")))
	status.add_child(core_bar)

	# Feedback teks tetap tersedia untuk logika, tetapi tidak memenuhi HUD.
	feedback_label = _make_label("", 10, Color("#e9c777"))
	feedback_label.visible = false
	status.add_child(feedback_label)

	# Statistik rinci disimpan untuk rekap akhir, bukan memenuhi HUD saat bermain.
	score_label = _make_label("SKOR 0", 10, Color("#f4e8c9"))
	score_label.visible = false
	energy_bar = ProgressBar.new()
	energy_bar.visible = false
	energy_bar.min_value = 0.0
	energy_bar.max_value = 999.0
	energy_bar.value = energy

	pause_button = _make_button("Ⅱ", Vector2(52, 72), false)
	pause_button.add_theme_font_size_override("font_size", 21)
	pause_button.tooltip_text = "Jeda permainan"
	pause_button.add_theme_stylebox_override("normal", _button_style(Color("#31482f"), Color("#bba87a"), 10, 4))
	pause_button.add_theme_stylebox_override("hover", _button_style(Color("#4a633d"), Color("#e8c36f"), 10, 4))
	pause_button.add_theme_stylebox_override("pressed", _button_style(Color("#223521"), Color("#e8c36f"), 10, 4))
	pause_button.pressed.connect(_toggle_pause)
	header.add_child(pause_button)
	var menu_button := _make_button("⌂", Vector2(52, 72), false)
	menu_button.add_theme_font_size_override("font_size", 22)
	menu_button.tooltip_text = "Kembali ke menu"
	menu_button.add_theme_stylebox_override("normal", _button_style(Color("#31482f"), Color("#bba87a"), 10, 4))
	menu_button.add_theme_stylebox_override("hover", _button_style(Color("#4a633d"), Color("#e8c36f"), 10, 4))
	menu_button.add_theme_stylebox_override("pressed", _button_style(Color("#223521"), Color("#e8c36f"), 10, 4))
	menu_button.pressed.connect(_return_to_menu)
	header.add_child(menu_button)

	# Arena memakai seluruh ruang utama.
	var arena_panel := PanelContainer.new()
	arena_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	arena_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	arena_panel.add_theme_stylebox_override("panel", _panel_style(Color("#405b36"), Color("#171a13"), 4, 2))
	outer.add_child(arena_panel)

	arena = ArenaViewScript.new()
	arena.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	arena.size_flags_vertical = Control.SIZE_EXPAND_FILL
	arena.slot_clicked.connect(_on_slot_clicked)
	arena_panel.add_child(arena)

	# Tantangan matematika muncul saat pergantian wave atau ketika pemain mengetuk tombol energi.
	question_popup = Control.new()
	question_popup.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	question_popup.visible = false
	question_popup.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(question_popup)

	var shade := ColorRect.new()
	shade.color = Color(0.06, 0.07, 0.04, 0.62)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	question_popup.add_child(shade)

	var popup_center := CenterContainer.new()
	popup_center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	popup_center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	question_popup.add_child(popup_center)

	var popup_panel := PanelContainer.new()
	popup_panel.custom_minimum_size = Vector2(minf(470.0, maxf(320.0, get_viewport_rect().size.x - 32.0)), 0)
	popup_panel.add_theme_stylebox_override("panel", _panel_style(Color("#eee2c4"), Color("#171a13"), 5, 16))
	popup_center.add_child(popup_panel)

	var popup_content := VBoxContainer.new()
	popup_content.add_theme_constant_override("separation", 8)
	popup_panel.add_child(popup_content)
	math_heading = _make_label("TANTANGAN ENERGI", 13, Color("#3d5a35"), HORIZONTAL_ALIGNMENT_CENTER)
	popup_content.add_child(math_heading)
	question_label = _make_label("12 + 8 = ?", 31, Color("#171a13"), HORIZONTAL_ALIGNMENT_CENTER)
	question_label.custom_minimum_size = Vector2(0, 48)
	popup_content.add_child(question_label)
	reward_hint_label = _make_label("BENAR +ENERGI  •  SALAH +15", 10, Color("#66583f"), HORIZONTAL_ALIGNMENT_CENTER)
	popup_content.add_child(reward_hint_label)

	# Dua kolom memberi target sentuh lebih besar pada layar HP.
	var answer_grid := GridContainer.new()
	answer_grid.columns = 2
	answer_grid.add_theme_constant_override("h_separation", 8)
	answer_grid.add_theme_constant_override("v_separation", 8)
	answer_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	popup_content.add_child(answer_grid)
	for index in range(4):
		var answer_button := _make_button("?", Vector2(136, 56), false)
		answer_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		answer_button.add_theme_font_size_override("font_size", 21)
		answer_button.pressed.connect(_on_answer_pressed.bind(index))
		answer_buttons.append(answer_button)
		answer_grid.add_child(answer_button)

	var close_button := _make_button("LEWATI SOAL", Vector2(0, 46), true)
	close_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	close_button.pressed.connect(_close_question_popup)
	popup_content.add_child(close_button)

	# Banner pergantian wave tampil di tengah arena, singkat dan tidak bisa menangkap sentuhan.
	wave_banner = Control.new()
	wave_banner.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	wave_banner.visible = false
	wave_banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(wave_banner)
	var banner_shade := ColorRect.new()
	banner_shade.color = Color(0.05, 0.07, 0.04, 0.38)
	banner_shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	banner_shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wave_banner.add_child(banner_shade)
	var banner_center := CenterContainer.new()
	banner_center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	banner_center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wave_banner.add_child(banner_center)
	var banner_panel := PanelContainer.new()
	banner_panel.custom_minimum_size = Vector2(270, 94)
	banner_panel.add_theme_stylebox_override("panel", _panel_style(Color("#243a29"), Color("#e8c36f"), 10, 14))
	banner_center.add_child(banner_panel)
	var banner_content := VBoxContainer.new()
	banner_content.add_theme_constant_override("separation", 3)
	banner_panel.add_child(banner_content)
	var banner_title := _make_label("WAVE 1", 25, Color("#f4e8c9"), HORIZONTAL_ALIGNMENT_CENTER)
	banner_title.name = "BannerTitle"
	banner_content.add_child(banner_title)
	var banner_subtitle := _make_label("SIAPKAN GUARDIAN", 11, Color("#d7c9a8"), HORIZONTAL_ALIGNMENT_CENTER)
	banner_subtitle.name = "BannerSubtitle"
	banner_content.add_child(banner_subtitle)

func _input(event: InputEvent) -> void:
	# Input mouse untuk editor PC dan input sentuh untuk target Android.
	# Drag kartu dimulai dari kartu Guardian, lalu dilepas pada petak arena.
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_begin_drag_candidate(event.position)
		else:
			_end_drag(event.position)
	elif event is InputEventMouseMotion:
		_update_drag(event.position)
	elif event is InputEventScreenTouch:
		if event.pressed:
			_begin_drag_candidate(event.position)
		else:
			_end_drag(event.position)
	elif event is InputEventScreenDrag:
		_update_drag(event.position)

func _begin_drag_candidate(position: Vector2) -> void:
	if battle_finished or paused:
		return
	for index in range(guardian_buttons.size()):
		var button: Button = guardian_buttons[index]
		var button_local: Vector2 = button.get_global_transform_with_canvas().affine_inverse() * position
		if Rect2(Vector2.ZERO, button.size).has_point(button_local) and not button.disabled:
			drag_candidate_type = guardian_button_types[index]
			drag_start_position = position
			drag_active = false
			return

func _update_drag(position: Vector2) -> void:
	if drag_candidate_type.is_empty():
		return
	if not drag_active and drag_start_position.distance_to(position) >= 12.0:
		drag_active = true
		selected_guardian = drag_candidate_type
		_update_guardian_button_styles()
		_refresh_hud()
	if drag_active and is_instance_valid(arena):
		var local_position: Vector2 = arena.get_global_transform_with_canvas().affine_inverse() * position
		arena.update_drag_preview(drag_candidate_type, local_position)
		get_viewport().set_input_as_handled()

func _end_drag(position: Vector2) -> void:
	if drag_candidate_type.is_empty():
		return
	if drag_active:
		if is_instance_valid(arena):
			var local_position: Vector2 = arena.get_global_transform_with_canvas().affine_inverse() * position
			var cell: Vector2i = arena.get_cell_at_local_position(local_position)
			if cell.x >= 0 and cell.y >= 0:
				_place_guardian_at(cell.x, cell.y)
			else:
				feedback_label.text = "Lepaskan kartu di petak arena."
				feedback_label.add_theme_color_override("font_color", Color("#f5d57d"))
				arena.reset_drag_preview()
		get_viewport().set_input_as_handled()
	drag_candidate_type = ""
	drag_active = false
	if is_instance_valid(arena):
		arena.reset_drag_preview()


func _difficulty_for_wave() -> String:
	# Untuk anak SD, dua wave pertama memakai soal mudah; wave terakhir sedang.
	if current_wave <= 2:
		return "mudah"
	return "sedang"

func _open_question_popup(is_wave_challenge: bool = false) -> void:
	if battle_finished or paused or question_popup_open:
		return
	if question_cooldown_timer > 0.0:
		feedback_label.text = "Soal berikutnya tersedia dalam %d detik." % ceili(question_cooldown_timer)
		feedback_label.add_theme_color_override("font_color", Color("#e9c777"))
		return

	# Soal hanya muncul jika pemain menekan tombol energi. Jeda 18 detik
	# setelah membuka soal membantu mencegah energi bisa di-farm terlalu cepat.
	question_cooldown_timer = QUESTION_COOLDOWN_SECONDS
	question_is_wave_challenge = false
	_new_question()
	question_popup_open = true
	question_result_showing = false
	paused = true
	question_popup.visible = true
	for button in answer_buttons:
		button.disabled = false
	_refresh_hud()

func _close_question_popup() -> void:
	if not question_popup_open or question_result_showing:
		return
	question_popup_open = false
	question_is_wave_challenge = false
	paused = false
	question_popup.visible = false
	feedback_label.text = "Soal dilewati • permainan tetap lanjut"
	feedback_label.add_theme_color_override("font_color", Color("#e9c777"))
	_refresh_hud()

func _new_question() -> void:
	current_question = QuestionGenerator.make_question(_difficulty_for_wave())
	question_label.text = "%d %s %d = ?" % [int(current_question["a"]), str(current_question["operator"]), int(current_question["b"])]
	if is_instance_valid(math_heading):
		if question_is_wave_challenge:
			math_heading.text = "TANTANGAN WAVE %d" % current_wave
		else:
			math_heading.text = "SOAL BONUS • WAVE %d" % current_wave
	if is_instance_valid(reward_hint_label):
		reward_hint_label.text = "BENAR +%d ENERGI  •  SALAH +3" % int(current_question["reward"])
	var options: Array = current_question["options"]
	for index in range(answer_buttons.size()):
		answer_buttons[index].text = str(options[index])
		answer_buttons[index].disabled = false

func _on_answer_pressed(index: int) -> void:
	if battle_finished or not question_popup_open or question_result_showing or index < 0 or index >= answer_buttons.size():
		return
	var options: Array = current_question["options"]
	if index >= options.size():
		return

	# Kunci tombol segera setelah jawaban dipilih untuk mencegah double-tap.
	question_result_showing = true
	for button in answer_buttons:
		button.disabled = true

	var chosen: int = int(options[index])
	var correct: int = int(current_question["answer"])
	var question_text: String = "%d %s %d" % [int(current_question["a"]), str(current_question["operator"]), int(current_question["b"])]
	total_questions += 1
	answer_history.append({
		"question": question_text,
		"chosen": chosen,
		"answer": correct,
		"correct": chosen == correct
	})

	# Tampilkan pembahasan sebentar sebelum gameplay dilanjutkan.
	question_label.text = "%s = %d" % [question_text, correct]
	if chosen == correct:
		correct_answers += 1
		combo += 1
		var reward: int = int(current_question["reward"])
		var combo_bonus: int = 5 if combo % 3 == 0 else 0
		var total_reward: int = reward + combo_bonus
		energy = mini(999, energy + total_reward)
		score += 100 + total_reward
		var combo_text: String = " • KOMBO!" if combo_bonus > 0 else ""
		feedback_label.text = "+%d energi%s" % [total_reward, combo_text]
		feedback_label.add_theme_color_override("font_color", Color("#536943"))
		if is_instance_valid(math_heading):
			math_heading.text = "HEBAT! JAWABAN BENAR"
		if is_instance_valid(reward_hint_label):
			reward_hint_label.text = "+%d ENERGI%s" % [total_reward, combo_text]
		if is_instance_valid(arena):
			arena.add_visual_effect("reward", Vector2(arena.size.x * 0.5, 34.0), Color("#d3ad5b"), "+%d ENERGI" % total_reward)
	else:
		wrong_answers += 1
		combo = 0
		energy = mini(999, energy + 3)
		feedback_label.text = "%s = %d  •  +3 energi" % [question_text, correct]
		feedback_label.add_theme_color_override("font_color", Color("#b95c49"))
		if is_instance_valid(math_heading):
			math_heading.text = "AYO BELAJAR BERSAMA!"
		if is_instance_valid(reward_hint_label):
			reward_hint_label.text = "Tetap dapat +3 energi • lanjut mencoba!"
		if is_instance_valid(arena):
			arena.add_visual_effect("reward", Vector2(arena.size.x * 0.5, 34.0), Color("#b95c49"), "JAWABAN %d" % correct)

	_refresh_hud()
	await get_tree().create_timer(1.15).timeout
	if not is_instance_valid(question_popup):
		return

	question_popup_open = false
	question_result_showing = false
	question_is_wave_challenge = false
	paused = false
	question_popup.visible = false
	_refresh_hud()

func _select_guardian(guardian_type: String) -> void:
	if battle_finished or paused:
		return
	var placement_cooldown: float = float(guardian_placement_cooldowns.get(guardian_type, 0.0))
	if placement_cooldown > 0.0:
		feedback_label.text = "%s siap dalam %d detik." % [guardian_type, ceili(placement_cooldown)]
		feedback_label.add_theme_color_override("font_color", Color("#e9c777"))
		return
	if energy < int(GUARDIAN_COSTS.get(guardian_type, 99999)) and selected_guardian != guardian_type:
		feedback_label.text = "Butuh %d energi." % int(GUARDIAN_COSTS.get(guardian_type, 0))
		feedback_label.add_theme_color_override("font_color", Color("#f2b4a8"))
		return
	if selected_guardian == guardian_type:
		selected_guardian = ""
		feedback_label.text = "Pilihan dibatalkan."
	else:
		selected_guardian = guardian_type
		feedback_label.text = "Seret kartu ke petak kosong."
		feedback_label.add_theme_color_override("font_color", Color("#fff4d6"))
	_update_guardian_button_styles()
	_refresh_hud()

func _on_slot_clicked(lane: int, column: int) -> void:
	_place_guardian_at(lane, column)

func _place_guardian_at(lane: int, column: int) -> void:
	if battle_finished or paused:
		return
	if selected_guardian.is_empty():
		feedback_label.text = "Seret kartu ke petak, atau ketuk kartu lalu petak."
		feedback_label.add_theme_color_override("font_color", Color("#f5d57d"))
		return
	for guardian in guardians:
		if int(guardian["lane"]) == lane and int(guardian["column"]) == column:
			feedback_label.text = "Petak sudah terisi."
			feedback_label.add_theme_color_override("font_color", Color("#f2b4a8"))
			return
	var guardian_type: String = selected_guardian
	var placement_cooldown: float = float(guardian_placement_cooldowns.get(guardian_type, 0.0))
	if placement_cooldown > 0.0:
		feedback_label.text = "%s siap dalam %d detik." % [guardian_type, ceili(placement_cooldown)]
		feedback_label.add_theme_color_override("font_color", Color("#e9c777"))
		return
	var cost: int = int(GUARDIAN_COSTS[guardian_type])
	if energy < cost:
		feedback_label.text = "Butuh %d energi." % cost
		feedback_label.add_theme_color_override("font_color", Color("#f2b4a8"))
		return
	energy -= cost
	guardian_placement_cooldowns[guardian_type] = float(GUARDIAN_PLACEMENT_COOLDOWNS.get(guardian_type, 6.0))
	var guardian_max_hp: int = 180
	match guardian_type:
		"Addy Cannon":
			guardian_max_hp = 170
		"Shield Cube":
			guardian_max_hp = 480
		"Multiply Dragon":
			guardian_max_hp = 190
		"Fraction Fairy":
			guardian_max_hp = 160
		"Number Knight":
			guardian_max_hp = 250
	guardians.append({
		"type": guardian_type,
		"lane": lane,
		"column": column,
		"hp": guardian_max_hp,
		"max_hp": guardian_max_hp,
		"cooldown": 0.0,
		"energy_timer": 0.0,
		"heal_timer": 0.0,
		"attack_anim": 0.0,
		"hurt_anim": 0.0
	})
	if is_instance_valid(arena):
		var placed_guardian: Dictionary = guardians[guardians.size() - 1]
		arena.add_visual_effect("spawn", arena.get_guardian_center(placed_guardian), Color("#a6e6b8"), "SIAP!")
	feedback_label.text = "%s ditempatkan" % guardian_type
	feedback_label.add_theme_color_override("font_color", Color("#a6e6b8"))
	selected_guardian = ""
	_update_guardian_button_styles()
	_refresh_hud()

func _start_next_wave() -> void:
	if current_wave > 0:
		score += 50
	current_wave += 1
	spawned_this_wave = 0
	spawn_target = WAVE_COUNTS[current_wave - 1]
	spawn_timer = 0.0
	intermission_timer = 0.0
	wave_question_pending = false
	bonus_question_used_this_wave = false
	feedback_label.text = ""
	_show_wave_banner(current_wave)

func _show_wave_banner(wave_number: int) -> void:
	if not is_instance_valid(wave_banner):
		return
	var title: Label = wave_banner.find_child("BannerTitle", true, false) as Label
	var subtitle: Label = wave_banner.find_child("BannerSubtitle", true, false) as Label
	if is_instance_valid(title):
		title.text = "WAVE %d" % wave_number
	if is_instance_valid(subtitle):
		match wave_number:
			1:
				subtitle.text = "MUSUH BISA DATANG DARI MANA SAJA"
			2:
				subtitle.text = "PERIKSA SEMUA JALUR"
			_:
				subtitle.text = "WASPADAI SETIAP BARIS"
	wave_banner.modulate.a = 1.0
	wave_banner.visible = true
	wave_banner_timer = 1.45

func _update_wave_banner(delta: float) -> void:
	if not is_instance_valid(wave_banner) or not wave_banner.visible:
		return
	wave_banner_timer -= delta
	if wave_banner_timer <= 0.0:
		wave_banner.visible = false
		wave_banner.modulate.a = 1.0
	elif wave_banner_timer < 0.28:
		wave_banner.modulate.a = clampf(wave_banner_timer / 0.28, 0.0, 1.0)

func _spawn_enemy() -> void:
	var enemy_type: String = "Error Blob"
	# Hanya ada satu musuh khusus pada wave terakhir; dua wave awal fokus belajar dasar.
	if current_wave >= 3:
		if spawned_this_wave == 3:
			enemy_type = "Calculator Bug"
		elif spawned_this_wave == 4:
			enemy_type = "Minus Monster"

	# HP meningkat secara bertahap setiap wave supaya monster lebih tangguh,
	# tanpa mempercepat gerakannya. Monster spesial tetap punya karakter sendiri.
	var hp: int = 90 + (current_wave - 1) * 15
	var speed: float = 9.5
	var core_damage: int = 6
	if enemy_type == "Minus Monster":
		hp = 150
		speed = 8.0
		core_damage = 6
	elif enemy_type == "Calculator Bug":
		hp = 125
		speed = 12.0
		core_damage = 5

	var lane: int = _choose_enemy_lane()
	enemies.append({
		"id": next_enemy_id,
		"type": enemy_type,
		"lane": lane,
		# Musuh masuk dari sisi kanan area bermain, bukan dari atas dekorasi.
		"x": arena.get_grid_right_edge() + 34.0,
		"hp": hp,
		"max_hp": hp,
		"speed": speed,
		"core_damage": core_damage,
		"attack_timer": 0.0,
		"hit_flash": 0.0
	})
	next_enemy_id += 1
	spawned_this_wave += 1


func _choose_enemy_lane() -> int:
	# Semua wave dapat menyerang kelima baris. Pemilihan acak menjaga strategi
	# tetap menarik, tetapi baris yang sama tidak dipilih dua kali berturut-turut.
	var available_lanes: Array[int] = [0, 1, 2, 3, 4]
	if last_spawned_lane >= 0:
		available_lanes.erase(last_spawned_lane)
	var chosen_lane: int = available_lanes[randi_range(0, available_lanes.size() - 1)]
	last_spawned_lane = chosen_lane
	return chosen_lane

func _update_guardians(delta: float) -> void:
	for index in range(guardians.size()):
		var guardian: Dictionary = guardians[index]
		var guardian_type: String = str(guardian["type"])
		guardian["attack_anim"] = maxf(0.0, float(guardian.get("attack_anim", 0.0)) - delta)
		guardian["hurt_anim"] = maxf(0.0, float(guardian.get("hurt_anim", 0.0)) - delta)
		if guardian_type == "Plusy":
			guardian["energy_timer"] = float(guardian.get("energy_timer", 0.0)) + delta
			if float(guardian["energy_timer"]) >= 7.5:
				guardian["energy_timer"] = float(guardian["energy_timer"]) - 7.5
				energy = mini(999, energy + 5)
				if is_instance_valid(arena):
					arena.add_visual_effect("reward", arena.get_guardian_center(guardian), Color("#a6e6b8"), "+5")
		elif guardian_type == "Addy Cannon" or guardian_type == "Multiply Dragon":
			guardian["cooldown"] = float(guardian.get("cooldown", 0.0)) - delta
			if float(guardian["cooldown"]) <= 0.0:
				var target_index: int = _find_target_index(guardian)
				if target_index >= 0:
					var target: Dictionary = enemies[target_index]
					var guardian_center: Vector2 = arena.get_guardian_center(guardian)
					var is_dragon: bool = guardian_type == "Multiply Dragon"
					projectiles.append({
						"kind": "fireball" if is_dragon else "orb",
						"lane": int(guardian["lane"]),
						"x": guardian_center.x + 20.0,
						"y": arena.get_lane_center(int(guardian["lane"])) - (10.0 if is_dragon else 7.0),
						"target_id": int(target["id"]),
						"speed": 240.0 if is_dragon else 280.0,
						"damage": 17 if is_dragon else 13,
						"splash_radius": 78.0 if is_dragon else 0.0,
						"splash_lane_radius": 1 if is_dragon else 0,
						"target_lane": int(target["lane"])
					})
					guardian["attack_anim"] = 0.24
					if is_dragon:
						arena.add_visual_effect("muzzle", guardian_center + Vector2(23.0, -5.0), Color("#f0a24f"), "FIRE!")
						guardian["cooldown"] = 1.7
					else:
						arena.add_visual_effect("muzzle", guardian_center + Vector2(23.0, -5.0), Color("#a8e9ff"))
						guardian["cooldown"] = 0.9
		elif guardian_type == "Fraction Fairy":
			guardian["heal_timer"] = float(guardian.get("heal_timer", 0.0)) + delta
			if float(guardian["heal_timer"]) >= 3.5:
				guardian["heal_timer"] = float(guardian["heal_timer"]) - 3.5
				var heal_target_index: int = _find_heal_target_index(guardian, index)
				if heal_target_index >= 0:
					var heal_target: Dictionary = guardians[heal_target_index]
					var old_hp: int = int(heal_target.get("hp", 0))
					var new_hp: int = mini(int(heal_target.get("max_hp", old_hp)), old_hp + 28)
					if new_hp > old_hp:
						heal_target["hp"] = new_hp
						guardians[heal_target_index] = heal_target
						if is_instance_valid(arena):
							arena.add_visual_effect("heal", arena.get_guardian_center(heal_target), Color("#a6e6b8"), "+%d HP" % (new_hp - old_hp))
		elif guardian_type == "Number Knight":
			guardian["cooldown"] = maxf(0.0, float(guardian.get("cooldown", 0.0)) - delta)
		guardians[index] = guardian

func _find_target_index(guardian: Dictionary) -> int:
	var guardian_center: Vector2 = arena.get_guardian_center(guardian)
	var guardian_type: String = str(guardian.get("type", ""))
	var attack_range: float = arena.get_attack_range()
	if guardian_type == "Multiply Dragon":
		attack_range *= 1.15
	var best_index: int = -1
	var best_distance: float = INF
	for index in range(enemies.size()):
		var enemy: Dictionary = enemies[index]
		if int(enemy["lane"]) != int(guardian["lane"]):
			continue
		var distance: float = float(enemy["x"]) - guardian_center.x
		if distance > 0.0 and distance <= attack_range and distance < best_distance:
			best_distance = distance
			best_index = index
	return best_index

func _find_heal_target_index(guardian: Dictionary, guardian_index: int) -> int:
	var best_index: int = -1
	var best_distance: float = INF
	for index in range(guardians.size()):
		if index == guardian_index:
			continue
		var target: Dictionary = guardians[index]
		if int(target.get("hp", 0)) >= int(target.get("max_hp", 0)):
			continue
		var lane_distance: int = absi(int(target.get("lane", 0)) - int(guardian.get("lane", 0)))
		var column_distance: int = absi(int(target.get("column", 0)) - int(guardian.get("column", 0)))
		if lane_distance > 1 or column_distance > 2:
			continue
		var distance: float = float(column_distance) + float(lane_distance) * 1.5
		if distance < best_distance:
			best_distance = distance
			best_index = index
	return best_index

func _update_projectiles(delta: float) -> void:
	for index in range(projectiles.size() - 1, -1, -1):
		var projectile: Dictionary = projectiles[index]
		var target_index: int = _find_enemy_by_id(int(projectile.get("target_id", -1)))
		if target_index < 0:
			projectiles.remove_at(index)
			continue
		var target: Dictionary = enemies[target_index]
		projectile["x"] = float(projectile["x"]) + float(projectile["speed"]) * delta
		if float(projectile["x"]) >= float(target["x"]) - 14.0:
			var damage: int = int(projectile.get("damage", 10))
			var impact_x: float = float(target["x"])
			var impact_lane: int = int(projectile.get("target_lane", target.get("lane", 0)))
			var splash_radius: float = float(projectile.get("splash_radius", 0.0))
			var splash_lane_radius: int = int(projectile.get("splash_lane_radius", 0))
			if splash_radius > 0.0:
				for enemy_index in range(enemies.size() - 1, -1, -1):
					var splash_target: Dictionary = enemies[enemy_index]
					if absf(float(splash_target.get("x", 0.0)) - impact_x) <= splash_radius and absi(int(splash_target.get("lane", 0)) - impact_lane) <= splash_lane_radius:
						splash_target["hp"] = int(splash_target.get("hp", 0)) - damage
						splash_target["hit_flash"] = 0.16
						enemies[enemy_index] = splash_target
						if is_instance_valid(arena):
							arena.add_visual_effect("hit", Vector2(float(splash_target.get("x", impact_x)), arena.get_lane_center(int(splash_target.get("lane", impact_lane)))), Color("#f0a24f"), "-%d" % damage)
			else:
				target["hp"] = int(target.get("hp", 0)) - damage
				target["hit_flash"] = 0.16
				enemies[target_index] = target
				if is_instance_valid(arena):
					arena.add_visual_effect("hit", Vector2(impact_x, arena.get_lane_center(int(target.get("lane", 0)))), Color("#ffd18c"), "-%d" % damage)
			projectiles.remove_at(index)
		else:
			projectiles[index] = projectile

func _find_enemy_by_id(enemy_id: int) -> int:
	for index in range(enemies.size()):
		if int(enemies[index].get("id", -1)) == enemy_id:
			return index
	return -1

func _update_enemies(delta: float) -> void:
	for index in range(enemies.size() - 1, -1, -1):
		var enemy: Dictionary = enemies[index]
		enemy["hit_flash"] = maxf(0.0, float(enemy.get("hit_flash", 0.0)) - delta)
		if int(enemy["hp"]) <= 0:
			if is_instance_valid(arena):
				arena.add_visual_effect("defeat", Vector2(float(enemy["x"]), arena.get_lane_center(int(enemy["lane"]))), Color("#a6e6b8"), "+20")
			enemies.remove_at(index)
			defeated_enemies += 1
			score += 20
			continue

		var blocking_index: int = _find_blocking_guardian(enemy)
		if blocking_index >= 0:
			var guardian: Dictionary = guardians[blocking_index]
			var guardian_type: String = str(guardian.get("type", ""))
			var guardian_x: float = arena.get_guardian_center(guardian).x
			# Monster berhenti di depan Guardian dan harus menghancurkannya sebelum lewat.
			enemy["x"] = guardian_x + 34.0

			# Number Knight membalas serangan dengan tebasan jarak dekat.
			if guardian_type == "Number Knight" and float(guardian.get("cooldown", 0.0)) <= 0.0:
				var knight_damage: int = 17
				enemy["hp"] = int(enemy.get("hp", 0)) - knight_damage
				enemy["hit_flash"] = 0.16
				guardian["attack_anim"] = 0.24
				guardian["cooldown"] = 0.82
				if is_instance_valid(arena):
					arena.add_visual_effect("hit", Vector2(float(enemy["x"]), arena.get_lane_center(int(enemy["lane"]))), Color("#f1d990"), "-%d" % knight_damage)
				if int(enemy["hp"]) <= 0:
					guardians[blocking_index] = guardian
					if is_instance_valid(arena):
						arena.add_visual_effect("defeat", Vector2(float(enemy["x"]), arena.get_lane_center(int(enemy["lane"]))), Color("#a6e6b8"), "+20")
					enemies.remove_at(index)
					defeated_enemies += 1
					score += 20
					continue
			guardians[blocking_index] = guardian

			enemy["attack_timer"] = float(enemy.get("attack_timer", 0.0)) + delta
			if float(enemy["attack_timer"]) >= 1.25:
				enemy["attack_timer"] = float(enemy["attack_timer"]) - 1.25
				var incoming_damage: int = 4 if guardian_type == "Shield Cube" else 6
				guardian["hp"] = int(guardian.get("hp", 180)) - incoming_damage
				guardian["hurt_anim"] = 0.20
				if is_instance_valid(arena):
					arena.add_visual_effect("hit", arena.get_guardian_center(guardian), Color("#f2b4a8"), "-%d" % incoming_damage)
				# Shield Cube memantulkan sebagian serangan sebagai duri pelindung.
				if guardian_type == "Shield Cube":
					var thorns_damage: int = 4
					enemy["hp"] = int(enemy.get("hp", 0)) - thorns_damage
					if is_instance_valid(arena):
						arena.add_visual_effect("hit", Vector2(float(enemy["x"]), arena.get_lane_center(int(enemy["lane"]))), Color("#f1d990"), "-%d" % thorns_damage)
				if int(guardian["hp"]) <= 0:
					if is_instance_valid(arena):
						arena.add_visual_effect("guardian_break", arena.get_guardian_center(guardian), Color("#f2b4a8"), "HANCUR")
					guardians.remove_at(blocking_index)
					feedback_label.text = "%s hancur" % guardian_type
				else:
					guardians[blocking_index] = guardian
				if int(enemy.get("hp", 0)) <= 0:
					if is_instance_valid(arena):
						arena.add_visual_effect("defeat", Vector2(float(enemy["x"]), arena.get_lane_center(int(enemy["lane"]))), Color("#a6e6b8"), "+20")
					enemies.remove_at(index)
					defeated_enemies += 1
					score += 20
					continue
			enemies[index] = enemy
		else:
			enemy["attack_timer"] = 0.0
			enemy["x"] = float(enemy["x"]) - float(enemy["speed"]) * delta
			var core_line: float = arena.get_grid_left_edge() - 14.0
			if float(enemy["x"]) <= core_line:
				var core_damage_amount: int = int(enemy.get("core_damage", 12))
				core_hp -= core_damage_amount
				if is_instance_valid(arena):
					arena.add_visual_effect("hit", Vector2(core_line, arena.get_lane_center(int(enemy["lane"]))), Color("#f2b4a8"), "CORE -%d" % core_damage_amount)
				# Musuh yang lolos tidak mengurangi energi; anak cukup belajar dari HP Core.
				feedback_label.text = "Inti terkena serangan (-%d HP)" % core_damage_amount
				feedback_label.add_theme_color_override("font_color", Color("#f2b4a8"))
				enemies.remove_at(index)
				if core_hp <= 0:
					core_hp = 0
					_finish_battle(false)
					return
			else:
				enemies[index] = enemy

func _find_blocking_guardian(enemy: Dictionary) -> int:
	# Semua Guardian menghalangi monster pada jalurnya. Shield memiliki HP tertinggi.
	var enemy_x: float = float(enemy.get("x", 0.0))
	var enemy_lane: int = int(enemy.get("lane", -1))
	var best_index: int = -1
	var nearest_distance: float = INF
	for index in range(guardians.size()):
		var guardian: Dictionary = guardians[index]
		if int(guardian.get("lane", -2)) != enemy_lane:
			continue
		var guardian_x: float = arena.get_guardian_center(guardian).x
		var distance: float = enemy_x - guardian_x
		# Monster bergerak dari kanan ke kiri; tangkap saat menyentuh Guardian.
		if distance >= -32.0 and distance <= 42.0 and absf(distance) < nearest_distance:
			nearest_distance = absf(distance)
			best_index = index
	return best_index

func _refresh_hud() -> void:
	if is_instance_valid(energy_button):
		energy_button.text = "✦ %d" % energy
	if is_instance_valid(core_label):
		core_label.text = "♥ %d" % core_hp
	if is_instance_valid(wave_label):
		wave_label.text = "WAVE %d" % max(current_wave, 1)
	if is_instance_valid(score_label):
		score_label.text = "SKOR %d" % score
	if is_instance_valid(core_bar):
		core_bar.value = core_hp
	if is_instance_valid(energy_bar):
		energy_bar.value = energy
	if is_instance_valid(wave_progress_label):
		wave_progress_label.text = "%d/%d" % [spawned_this_wave, spawn_target]
	if is_instance_valid(arena):
		arena.guardians = guardians
		arena.enemies = enemies
		arena.projectiles = projectiles
		arena.placement_enabled = not selected_guardian.is_empty() and not paused and not battle_finished
		arena.queue_redraw()
	_update_wave_segments()
	_update_guardian_button_styles()
	_update_cooldown_visuals()

func _update_wave_segments() -> void:
	if last_wave_segment_state == current_wave:
		return
	last_wave_segment_state = current_wave
	for index in range(wave_segments.size()):
		var active: bool = index < current_wave
		var fill: Color = Color("#d9b75f") if active else Color("#53634a")
		var border: Color = Color("#f1d990") if active else Color("#53634a")
		wave_segments[index].add_theme_stylebox_override("panel", _panel_style(fill, border, 3, 0))

func _update_guardian_button_styles() -> void:
	var card_colors: Dictionary = {
		"Plusy": Color("#536943"),
		"Addy Cannon": Color("#637e7a"),
		"Shield Cube": Color("#9c783e"),
		"Multiply Dragon": Color("#89533a"),
		"Fraction Fairy": Color("#655b7e"),
		"Number Knight": Color("#52616b")
	}
	var card_borders: Dictionary = {
		"Plusy": Color("#d9d0a5"),
		"Addy Cannon": Color("#d9d0a5"),
		"Shield Cube": Color("#e8c36f"),
		"Multiply Dragon": Color("#f0a24f"),
		"Fraction Fairy": Color("#c4b0e7"),
		"Number Knight": Color("#b9d0db")
	}
	for index in range(guardian_buttons.size()):
		var guardian_type: String = guardian_button_types[index]
		var is_selected: bool = guardian_type == selected_guardian
		var can_afford: bool = energy >= int(GUARDIAN_COSTS.get(guardian_type, 99999))
		var remaining_cooldown: float = float(guardian_placement_cooldowns.get(guardian_type, 0.0))
		var is_cooling: bool = remaining_cooldown > 0.0
		guardian_buttons[index].disabled = not can_afford or paused or battle_finished or is_cooling
		var base_color: Color = card_colors[guardian_type]
		var border_color: Color = Color("#e8c36f") if is_selected else card_borders[guardian_type]
		guardian_buttons[index].add_theme_stylebox_override("normal", _button_style(base_color.lightened(0.12) if is_selected else base_color, border_color, 6, 2))
		guardian_buttons[index].add_theme_stylebox_override("hover", _button_style(base_color.lightened(0.24), border_color.lightened(0.15), 6, 2))
		guardian_buttons[index].add_theme_stylebox_override("pressed", _button_style(base_color.darkened(0.12), border_color, 6, 2))
		guardian_buttons[index].add_theme_stylebox_override("disabled", _button_style(base_color.darkened(0.48) if is_cooling else base_color.darkened(0.20), border_color.darkened(0.35) if is_cooling else border_color.darkened(0.15), 6, 2))
		guardian_buttons[index].add_theme_color_override("font_color", Color("#f5edd9") if can_afford else Color("#b3ad98"))
		guardian_buttons[index].add_theme_color_override("font_disabled_color", Color("#8e8b7b") if is_cooling else Color("#b3ad98"))

func _toggle_pause() -> void:
	if battle_finished or question_popup_open:
		return
	paused = not paused
	pause_button.text = "▶" if paused else "Ⅱ"
	pause_button.tooltip_text = "Lanjutkan permainan" if paused else "Jeda permainan"
	feedback_label.text = "Dijeda" if paused else "Lanjut bermain"
	feedback_label.add_theme_color_override("font_color", Color("#fff4d6"))
	for button in answer_buttons:
		button.disabled = paused
	_update_guardian_button_styles()
	_refresh_hud()

func _finish_battle(victory: bool) -> void:
	if battle_finished:
		return
	battle_finished = true
	paused = false
	question_popup_open = false
	question_result_showing = false
	wave_question_pending = false
	if is_instance_valid(question_popup):
		question_popup.visible = false
	selected_guardian = ""
	_save_best_score()
	if is_instance_valid(arena):
		arena.placement_enabled = false
	for button in answer_buttons:
		button.disabled = true
	for button in guardian_buttons:
		button.disabled = true
	if is_instance_valid(pause_button):
		pause_button.disabled = true

	var overlay := ColorRect.new()
	overlay.color = Color(0.06, 0.07, 0.04, 0.84)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(overlay)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(minf(540.0, maxf(320.0, get_viewport_rect().size.x - 32.0)), 0)
	panel.add_theme_stylebox_override("panel", _panel_style(Color("#eee2c4"), Color("#171a13"), 5, 22))
	center.add_child(panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 11)
	panel.add_child(content)
	var title_text: String = "NUMERIA SELAMAT!" if victory else "CORE NUMERIA RUNTUH"
	var detail_text: String = "Hebat! Kamu berhasil melewati semua wave." if victory else "Coba susun Guardian pada jalur yang berbeda dan jawab soal untuk memperoleh energi."
	var title := _make_label(title_text, 26, Color("#171a13"), HORIZONTAL_ALIGNMENT_CENTER)
	content.add_child(title)
	var detail := _make_label(detail_text, 14, Color("#4c4b38"), HORIZONTAL_ALIGNMENT_CENTER)
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(detail)
	var accuracy: int = roundi(float(correct_answers) / float(maxi(total_questions, 1)) * 100.0)
	var stats := _make_label("Skor %d  •  Musuh dikalahkan %d\nBenar %d  •  Salah %d  •  Akurasi %d%%" % [score, defeated_enemies, correct_answers, wrong_answers, accuracy], 13, Color("#3d5a35"), HORIZONTAL_ALIGNMENT_CENTER)
	stats.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stats.custom_minimum_size = Vector2(0, 42)
	content.add_child(stats)
	var review_button := _make_button("LIHAT PEMBAHASAN SOAL", Vector2(0, 46), false)
	review_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_child(review_button)
	var review_label := _make_label(_build_review_text(), 12, Color("#4c4b38"), HORIZONTAL_ALIGNMENT_CENTER)
	review_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	review_label.custom_minimum_size = Vector2(0, 96)
	review_label.visible = false
	content.add_child(review_label)
	review_button.pressed.connect(func() -> void:
		review_label.visible = not review_label.visible
		review_button.text = "SEMBUNYIKAN PEMBAHASAN" if review_label.visible else "LIHAT PEMBAHASAN SOAL"
	)
	var replay := _make_button("MAIN LAGI", Vector2(0, 48), true)
	replay.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	replay.pressed.connect(func() -> void: get_tree().reload_current_scene())
	content.add_child(replay)
	var menu := _make_button("MENU UTAMA", Vector2(0, 46), false)
	menu.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	menu.pressed.connect(_return_to_menu)
	content.add_child(menu)

func _build_review_text() -> String:
	var wrong_records: Array[Dictionary] = []
	for record in answer_history:
		if not bool(record.get("correct", false)):
			wrong_records.append(record)
	if wrong_records.is_empty():
		return "Hebat! Semua jawabanmu benar. Tidak ada soal yang perlu diulas."
	var lines: Array[String] = ["Pembahasan 4 jawaban salah terakhir:"]
	var start_index: int = maxi(0, wrong_records.size() - 4)
	for index in range(start_index, wrong_records.size()):
		var record: Dictionary = wrong_records[index]
		lines.append("%s  •  Jawabanmu: %s  •  Jawaban benar: %s" % [str(record.get("question", "")), str(record.get("chosen", "")), str(record.get("answer", ""))])
	return "\n".join(lines)

func _save_best_score() -> void:
	var save_data := ConfigFile.new()
	save_data.load("user://math_adventure.cfg")
	var previous_best: int = int(save_data.get_value("stats", "best_score", 0))
	if score > previous_best:
		save_data.set_value("stats", "best_score", score)
		save_data.save("user://math_adventure.cfg")

func _return_to_menu() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)

func _make_label(value: String, font_size: int, color: Color, alignment: int = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var label := Label.new()
	label.text = value
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label

func _make_button(value: String, minimum_size: Vector2, primary: bool) -> Button:
	var button := Button.new()
	button.text = value
	button.custom_minimum_size = minimum_size
	button.add_theme_font_size_override("font_size", 15 if primary else 13)
	button.add_theme_color_override("font_color", Color("#171a13") if primary else Color("#f4e8c9"))
	button.add_theme_color_override("font_hover_color", Color("#171a13") if primary else Color("#fff9e8"))
	button.add_theme_stylebox_override("normal", _button_style(Color("#d3ad5b") if primary else Color("#31482f"), Color("#171a13"), 5, 8))
	button.add_theme_stylebox_override("hover", _button_style(Color("#e4c779") if primary else Color("#455f3d"), Color("#171a13"), 5, 8))
	button.add_theme_stylebox_override("pressed", _button_style(Color("#b78e42") if primary else Color("#223521"), Color("#171a13"), 5, 8))
	button.add_theme_stylebox_override("focus", _button_style(Color(0.0, 0.0, 0.0, 0.0), Color("#e8c36f"), 5, 8))
	return button

func _meter_style(background: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.set_corner_radius_all(6)
	style.set_content_margin_all(0)
	return style

func _button_style(background: Color, border: Color, radius: int, padding: int) -> StyleBoxFlat:
	return _panel_style(background, border, radius, padding)

func _panel_style(background: Color, border: Color, radius: int, padding: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(mini(radius, 5))
	style.set_border_width_all(2)
	style.set_content_margin_all(padding)
	return style
