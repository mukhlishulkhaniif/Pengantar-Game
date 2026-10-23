extends Control

const MAIN_MENU_SCENE: String = "res://scenes/main_menu.tscn"
const ArenaViewScript = preload("res://scripts/presentation/arena_view.gd")
const QuestionGenerator = preload("res://scripts/domain/question_generator.gd")
const WAVE_COUNTS: Array[int] = [3, 4, 5]
const GUARDIAN_COSTS: Dictionary = {"Plusy": 50, "Addy Cannon": 100, "Shield Cube": 75}
const GUARDIAN_DESCRIPTIONS: Dictionary = {
	"Plusy": "Penghasil energi • 50",
	"Addy Cannon": "Penyerang jarak jauh • 100",
	"Shield Cube": "Pelindung Core • 75"
}

var energy: int = 100
var core_hp: int = 100
var combo: int = 0
var current_wave: int = 0
var spawned_this_wave: int = 0
var spawn_target: int = 0
var spawn_timer: float = 0.0
var intermission_timer: float = 0.0
var passive_energy_timer: float = 0.0
var battle_finished: bool = false
var selected_guardian: String = ""
var guardians: Array = []
var enemies: Array = []
var current_question: Dictionary = {}
var arena
var energy_label: Label
var core_label: Label
var wave_label: Label
var question_label: Label
var feedback_label: Label
var answer_buttons: Array[Button] = []
var guardian_buttons: Array[Button] = []
var guardian_button_types: Array[String] = ["Plusy", "Addy Cannon", "Shield Cube"]

func _ready() -> void:
	randomize()
	_build_ui()
	_new_question()
	_start_next_wave()
	_refresh_hud()

func _process(delta: float) -> void:
	if battle_finished:
		return

	passive_energy_timer += delta
	if passive_energy_timer >= 5.0:
		passive_energy_timer -= 5.0
		energy += 1

	if spawned_this_wave < spawn_target:
		spawn_timer += delta
		if spawn_timer >= 2.1:
			spawn_timer = 0.0
			_spawn_enemy()

	_update_guardians(delta)
	_update_enemies(delta)

	if spawned_this_wave >= spawn_target and enemies.is_empty():
		if current_wave < WAVE_COUNTS.size():
			intermission_timer += delta
			if intermission_timer >= 2.0:
				_start_next_wave()
		else:
			_finish_battle(true)

	_refresh_hud()

func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color("#102b32")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 22)
	margin.add_theme_constant_override("margin_right", 22)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	add_child(margin)

	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 10)
	outer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(outer)

	var header := HBoxContainer.new()
	header.custom_minimum_size = Vector2(0, 46)
	header.add_theme_constant_override("separation", 18)
	outer.add_child(header)

	var title := _make_label("MATH-ADVENTURE", 23, Color("#fff4d6"))
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)
	energy_label = _make_label("MATH ENERGY  100", 16, Color("#a6e6b8"))
	header.add_child(energy_label)
	core_label = _make_label("CORE  100/100", 16, Color("#f5d57d"))
	header.add_child(core_label)
	wave_label = _make_label("WAVE  1/3", 16, Color("#c9d9f4"))
	header.add_child(wave_label)

	var body := HBoxContainer.new()
	body.add_theme_constant_override("separation", 14)
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	outer.add_child(body)

	var arena_panel := PanelContainer.new()
	arena_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	arena_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	arena_panel.add_theme_stylebox_override("panel", _panel_style(Color("#173a32"), Color("#3d6d54"), 18, 10))
	body.add_child(arena_panel)

	arena = ArenaViewScript.new()
	arena.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	arena.size_flags_vertical = Control.SIZE_EXPAND_FILL
	arena.slot_clicked.connect(_on_slot_clicked)
	arena_panel.add_child(arena)

	var side_panel := PanelContainer.new()
	side_panel.custom_minimum_size = Vector2(315, 0)
	side_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	side_panel.add_theme_stylebox_override("panel", _panel_style(Color("#1a4140"), Color("#35675b"), 18, 14))
	body.add_child(side_panel)

	var side := VBoxContainer.new()
	side.add_theme_constant_override("separation", 8)
	side_panel.add_child(side)

	var math_heading := _make_label("TANTANGAN MATEMATIKA", 16, Color("#a6e6b8"))
	side.add_child(math_heading)
	question_label = _make_label("12 + 8 = ?", 30, Color("#fff4d6"), HORIZONTAL_ALIGNMENT_CENTER)
	question_label.custom_minimum_size = Vector2(0, 52)
	side.add_child(question_label)

	var answer_grid := GridContainer.new()
	answer_grid.columns = 2
	answer_grid.add_theme_constant_override("h_separation", 8)
	answer_grid.add_theme_constant_override("v_separation", 8)
	side.add_child(answer_grid)
	for index in range(4):
		var answer_button := _make_button("?", Vector2(0, 48), false)
		answer_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		answer_button.pressed.connect(_on_answer_pressed.bind(index))
		answer_buttons.append(answer_button)
		answer_grid.add_child(answer_button)

	feedback_label = _make_label("Jawab soal untuk mendapatkan energi.", 13, Color("#d2e5dc"))
	feedback_label.custom_minimum_size = Vector2(0, 38)
	feedback_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	side.add_child(feedback_label)

	var divider := HSeparator.new()
	side.add_child(divider)
	var guardian_heading := _make_label("PILIH MATH GUARDIAN", 16, Color("#a6e6b8"))
	side.add_child(guardian_heading)

	for guardian_type in guardian_button_types:
		var guardian_button := _make_button(str(GUARDIAN_DESCRIPTIONS[guardian_type]), Vector2(0, 43), false)
		guardian_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		guardian_button.add_theme_font_size_override("font_size", 13)
		guardian_button.pressed.connect(_select_guardian.bind(guardian_type))
		guardian_buttons.append(guardian_button)
		side.add_child(guardian_button)

	var guardian_help := _make_label("Pilih Guardian, lalu klik petak arena. Guardian hanya bisa ditempatkan pada petak kosong.", 12, Color("#9fbdb2"))
	guardian_help.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	side.add_child(guardian_help)

	var footer := HBoxContainer.new()
	footer.add_theme_constant_override("separation", 12)
	outer.add_child(footer)
	var instruction := _make_label("BERTAHANLAH!  •  Jawab soal  →  Kumpulkan energi  →  Tempatkan Guardian", 13, Color("#9fbdb2"))
	instruction.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	footer.add_child(instruction)
	var menu_button := _make_button("MENU", Vector2(100, 34), false)
	menu_button.add_theme_font_size_override("font_size", 12)
	menu_button.pressed.connect(_return_to_menu)
	footer.add_child(menu_button)

func _new_question() -> void:
	current_question = QuestionGenerator.make_question()
	question_label.text = "%d %s %d = ?" % [int(current_question["a"]), str(current_question["operator"]), int(current_question["b"])]
	var options: Array = current_question["options"]
	for index in range(answer_buttons.size()):
		answer_buttons[index].text = str(options[index])
		answer_buttons[index].disabled = false

func _on_answer_pressed(index: int) -> void:
	if battle_finished:
		return
	var options: Array = current_question["options"]
	var chosen: int = int(options[index])
	var correct: int = int(current_question["answer"])
	if chosen == correct:
		combo += 1
		var reward: int = 30
		if combo > 0 and combo % 3 == 0:
			reward += 10
		energy += reward
		feedback_label.text = "Benar! +%d Math Energy.%s" % [reward, " Combo x%d!" % combo if combo >= 3 else ""]
		feedback_label.add_theme_color_override("font_color", Color("#a6e6b8"))
	else:
		combo = 0
		energy += 10
		feedback_label.text = "Belum tepat. +10 energi, coba soal berikutnya!"
		feedback_label.add_theme_color_override("font_color", Color("#f2b4a8"))
	_new_question()
	_refresh_hud()

func _select_guardian(guardian_type: String) -> void:
	if battle_finished:
		return
	if selected_guardian == guardian_type:
		selected_guardian = ""
		feedback_label.text = "Pilihan Guardian dibatalkan."
	else:
		selected_guardian = guardian_type
		feedback_label.text = "Dipilih: %s. Klik petak kosong di arena." % guardian_type
		feedback_label.add_theme_color_override("font_color", Color("#fff4d6"))
	for index in range(guardian_buttons.size()):
		var is_selected: bool = guardian_button_types[index] == selected_guardian
		guardian_buttons[index].add_theme_stylebox_override("normal", _button_style(Color("#a6e6b8") if is_selected else Color("#28564c"), Color("#d9ffe0") if is_selected else Color("#4d7b68"), 10, 8))
		guardian_buttons[index].add_theme_color_override("font_color", Color("#102b32") if is_selected else Color("#e5f1e9"))

func _on_slot_clicked(lane: int, column: int) -> void:
	if battle_finished or selected_guardian.is_empty():
		return
	for guardian in guardians:
		if int(guardian["lane"]) == lane and int(guardian["column"]) == column:
			feedback_label.text = "Petak itu sudah ditempati Guardian."
			feedback_label.add_theme_color_override("font_color", Color("#f2b4a8"))
			return
	var cost: int = int(GUARDIAN_COSTS[selected_guardian])
	if energy < cost:
		feedback_label.text = "Energi belum cukup. Butuh %d." % cost
		feedback_label.add_theme_color_override("font_color", Color("#f2b4a8"))
		return
	energy -= cost
	guardians.append({
		"type": selected_guardian,
		"lane": lane,
		"column": column,
		"hp": 300 if selected_guardian == "Shield Cube" else 100,
		"cooldown": 0.0,
		"energy_timer": 0.0,
		"attack_timer": 0.0
	})
	feedback_label.text = "%s berhasil ditempatkan!" % selected_guardian
	feedback_label.add_theme_color_override("font_color", Color("#a6e6b8"))
	selected_guardian = ""
	for index in range(guardian_buttons.size()):
		guardian_buttons[index].add_theme_stylebox_override("normal", _button_style(Color("#28564c"), Color("#4d7b68"), 10, 8))
		guardian_buttons[index].add_theme_color_override("font_color", Color("#e5f1e9"))
	_refresh_hud()

func _start_next_wave() -> void:
	current_wave += 1
	spawned_this_wave = 0
	spawn_target = WAVE_COUNTS[current_wave - 1]
	spawn_timer = 0.0
	intermission_timer = 0.0
	feedback_label.text = "Wave %d dimulai! Lindungi Core Numeria." % current_wave
	feedback_label.add_theme_color_override("font_color", Color("#fff4d6"))

func _spawn_enemy() -> void:
	var is_minus: bool = current_wave >= 2 and spawned_this_wave % 3 == 2
	var enemy_type: String = "Minus Monster" if is_minus else "Error Blob"
	var hp: int = 100 if is_minus else 50
	var speed: float = 30.0 if is_minus else 37.0
	var lane: int = randi_range(0, 2)
	enemies.append({
		"type": enemy_type,
		"lane": lane,
		"x": maxf(arena.size.x - 35.0, 650.0),
		"hp": hp,
		"max_hp": hp,
		"speed": speed,
		"attack_timer": 0.0
	})
	spawned_this_wave += 1

func _update_guardians(delta: float) -> void:
	for index in range(guardians.size()):
		var guardian: Dictionary = guardians[index]
		var guardian_type: String = str(guardian["type"])
		if guardian_type == "Plusy":
			guardian["energy_timer"] = float(guardian.get("energy_timer", 0.0)) + delta
			if float(guardian["energy_timer"]) >= 5.0:
				guardian["energy_timer"] = float(guardian["energy_timer"]) - 5.0
				energy += 5
		elif guardian_type == "Addy Cannon":
			guardian["cooldown"] = float(guardian.get("cooldown", 0.0)) - delta
			if float(guardian["cooldown"]) <= 0.0:
				var target_index: int = _find_target_index(guardian)
				if target_index >= 0:
					var target: Dictionary = enemies[target_index]
					target["hp"] = int(target["hp"]) - 25
					enemies[target_index] = target
					guardian["cooldown"] = 1.0
		guardians[index] = guardian

func _find_target_index(guardian: Dictionary) -> int:
	var guardian_center: Vector2 = arena.get_guardian_center(guardian)
	var best_index: int = -1
	var best_distance: float = INF
	for index in range(enemies.size()):
		var enemy: Dictionary = enemies[index]
		if int(enemy["lane"]) != int(guardian["lane"]):
			continue
		var distance: float = float(enemy["x"]) - guardian_center.x
		if distance > 0.0 and distance <= 360.0 and distance < best_distance:
			best_distance = distance
			best_index = index
	return best_index

func _update_enemies(delta: float) -> void:
	for index in range(enemies.size() - 1, -1, -1):
		var enemy: Dictionary = enemies[index]
		if int(enemy["hp"]) <= 0:
			enemies.remove_at(index)
			continue
		var shield_index: int = _find_blocking_shield(enemy)
		if shield_index >= 0:
			var shield: Dictionary = guardians[shield_index]
			enemy["attack_timer"] = float(enemy.get("attack_timer", 0.0)) + delta
			if float(enemy["attack_timer"]) >= 1.0:
				enemy["attack_timer"] = float(enemy["attack_timer"]) - 1.0
				shield["hp"] = int(shield["hp"]) - 15
				if int(shield["hp"]) <= 0:
					guardians.remove_at(shield_index)
					feedback_label.text = "Shield Cube hancur! Tempatkan Guardian lain."
				else:
					guardians[shield_index] = shield
			enemies[index] = enemy
		else:
			enemy["x"] = float(enemy["x"]) - float(enemy["speed"]) * delta
			if float(enemy["x"]) <= 30.0:
				core_hp -= 20
				enemies.remove_at(index)
				feedback_label.text = "Core terkena serangan! Jaga jalur pertahanan."
				feedback_label.add_theme_color_override("font_color", Color("#f2b4a8"))
				if core_hp <= 0:
					core_hp = 0
					_finish_battle(false)
				return
			enemies[index] = enemy

func _find_blocking_shield(enemy: Dictionary) -> int:
	for index in range(guardians.size()):
		var guardian: Dictionary = guardians[index]
		if str(guardian["type"]) != "Shield Cube" or int(guardian["lane"]) != int(enemy["lane"]):
			continue
		var guardian_x: float = arena.get_guardian_center(guardian).x
		if float(enemy["x"]) <= guardian_x + 31.0 and float(enemy["x"]) >= guardian_x - 10.0:
			return index
	return -1

func _refresh_hud() -> void:
	if is_instance_valid(energy_label):
		energy_label.text = "MATH ENERGY  %d" % energy
		core_label.text = "CORE  %d/100" % core_hp
		wave_label.text = "WAVE  %d/3" % max(current_wave, 1)
	if is_instance_valid(arena):
		arena.guardians = guardians
		arena.enemies = enemies
		arena.queue_redraw()

func _finish_battle(victory: bool) -> void:
	if battle_finished:
		return
	battle_finished = true
	var overlay := ColorRect.new()
	overlay.color = Color(0.02, 0.07, 0.07, 0.82)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(overlay)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(440, 250)
	panel.add_theme_stylebox_override("panel", _panel_style(Color("#1a4140"), Color("#8ccca2"), 22, 24))
	center.add_child(panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 14)
	panel.add_child(content)
	var title_text: String = "NUMERIA SELAMAT!" if victory else "CORE NUMERIA RUNTUH"
	var detail_text: String = "Hebat! Kamu berhasil melewati semua wave." if victory else "Jangan menyerah. Coba strategi Guardian yang berbeda."
	var title := _make_label(title_text, 27, Color("#fff4d6"), HORIZONTAL_ALIGNMENT_CENTER)
	content.add_child(title)
	var detail := _make_label(detail_text, 16, Color("#c2d9d3"), HORIZONTAL_ALIGNMENT_CENTER)
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(detail)
	var replay := _make_button("MAIN LAGI", Vector2(0, 48), true)
	replay.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	replay.pressed.connect(func() -> void: get_tree().reload_current_scene())
	content.add_child(replay)
	var menu := _make_button("MENU UTAMA", Vector2(0, 42), false)
	menu.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	menu.pressed.connect(_return_to_menu)
	content.add_child(menu)

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
	button.add_theme_font_size_override("font_size", 15 if primary else 14)
	button.add_theme_color_override("font_color", Color("#102b32") if primary else Color("#e5f1e9"))
	button.add_theme_color_override("font_hover_color", Color("#102b32") if primary else Color("#ffffff"))
	button.add_theme_stylebox_override("normal", _button_style(Color("#a6e6b8") if primary else Color("#28564c"), Color("#c6f2d2") if primary else Color("#4d7b68"), 10, 8))
	button.add_theme_stylebox_override("hover", _button_style(Color("#c1f2cb") if primary else Color("#36705d"), Color("#e0ffe5") if primary else Color("#76a88d"), 10, 8))
	button.add_theme_stylebox_override("pressed", _button_style(Color("#81c99b") if primary else Color("#1c423a"), Color("#a6e6b8") if primary else Color("#4d7b68"), 10, 8))
	button.add_theme_stylebox_override("focus", _button_style(Color(0, 0, 0, 0), Color("#fff4d6"), 10, 8))
	return button

func _button_style(background: Color, border: Color, radius: int, padding: int) -> StyleBoxFlat:
	return _panel_style(background, border, radius, padding)

func _panel_style(background: Color, border: Color, radius: int, padding: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(radius)
	style.set_content_margin_all(padding)
	return style
