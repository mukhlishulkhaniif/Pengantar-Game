extends Control

const MAIN_MENU_SCENE: String = "res://scenes/main_menu.tscn"
const ArenaViewScript = preload("res://scripts/presentation/arena_view.gd")
const QuestionGenerator = preload("res://scripts/domain/question_generator.gd")
const WAVE_COUNTS: Array[int] = [4, 6, 8]
const GUARDIAN_COSTS: Dictionary = {"Plusy": 50, "Addy Cannon": 100, "Shield Cube": 75}
const GUARDIAN_DESCRIPTIONS: Dictionary = {
	"Plusy": "PLUSY  •  Penghasil energi  •  50",
	"Addy Cannon": "ADDY CANNON  •  Penyerang  •  100",
	"Shield Cube": "SHIELD CUBE  •  Pelindung  •  75"
}

var energy: int = 100
var core_hp: int = 100
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
var intermission_timer: float = 0.0
var passive_energy_timer: float = 0.0
var next_enemy_id: int = 1
var battle_finished: bool = false
var paused: bool = false
var selected_guardian: String = ""
var guardians: Array = []
var enemies: Array = []
var projectiles: Array = []
var current_question: Dictionary = {}
var arena
var energy_label: Label
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
var guardian_buttons: Array[Button] = []
var guardian_button_types: Array[String] = ["Plusy", "Addy Cannon", "Shield Cube"]

func _ready() -> void:
	randomize()
	_build_ui()
	_start_next_wave()
	_refresh_hud()

func _process(delta: float) -> void:
	if battle_finished or paused:
		return

	passive_energy_timer += delta
	if passive_energy_timer >= 8.0:
		passive_energy_timer -= 8.0
		energy = mini(999, energy + 1)

	if spawned_this_wave < spawn_target:
		spawn_timer += delta
		var spawn_interval: float = maxf(1.15, 1.75 - float(current_wave - 1) * 0.2)
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
			if intermission_timer >= 2.2:
				_start_next_wave()
		else:
			_finish_battle(true)

	_refresh_hud()

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	if key_event.keycode == KEY_ESCAPE:
		_toggle_pause()
		get_viewport().set_input_as_handled()
		return
	if battle_finished or paused:
		return
	match key_event.keycode:
		KEY_1:
			_select_guardian("Plusy")
		KEY_2:
			_select_guardian("Addy Cannon")
		KEY_3:
			_select_guardian("Shield Cube")

func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color("#102b32")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_bottom", 12)
	add_child(margin)

	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 9)
	outer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(outer)

	var header := HBoxContainer.new()
	header.custom_minimum_size = Vector2(0, 42)
	header.add_theme_constant_override("separation", 12)
	outer.add_child(header)

	var title := _make_label("MATH-ADVENTURE", 22, Color("#fff4d6"))
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)
	energy_label = _make_label("ENERGI  100", 15, Color("#a6e6b8"))
	header.add_child(energy_label)
	core_label = _make_label("CORE  100/100", 15, Color("#f5d57d"))
	header.add_child(core_label)
	wave_label = _make_label("WAVE  1/3", 15, Color("#c9d9f4"))
	header.add_child(wave_label)
	score_label = _make_label("SKOR  0", 15, Color("#e9c6ff"))
	header.add_child(score_label)

	# Meter status membuat kondisi permainan terbaca tanpa menutupi arena.
	var status_row := HBoxContainer.new()
	status_row.add_theme_constant_override("separation", 14)
	status_row.custom_minimum_size = Vector2(0, 42)
	outer.add_child(status_row)

	var core_meter := VBoxContainer.new()
	core_meter.custom_minimum_size = Vector2(190, 0)
	core_meter.add_theme_constant_override("separation", 2)
	status_row.add_child(core_meter)
	core_meter.add_child(_make_label("KEKUATAN CORE", 10, Color("#f5d57d")))
	core_bar = ProgressBar.new()
	core_bar.min_value = 0.0
	core_bar.max_value = 100.0
	core_bar.value = core_hp
	core_bar.show_percentage = false
	core_bar.custom_minimum_size = Vector2(180, 12)
	core_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	core_bar.add_theme_stylebox_override("background", _meter_style(Color("#3a3030")))
	core_bar.add_theme_stylebox_override("fill", _meter_style(Color("#e9b85c")))
	core_meter.add_child(core_bar)

	var energy_meter := VBoxContainer.new()
	energy_meter.custom_minimum_size = Vector2(190, 0)
	energy_meter.add_theme_constant_override("separation", 2)
	status_row.add_child(energy_meter)
	energy_meter.add_child(_make_label("MATH ENERGY", 10, Color("#a6e6b8")))
	energy_bar = ProgressBar.new()
	energy_bar.min_value = 0.0
	energy_bar.max_value = 999.0
	energy_bar.value = energy
	energy_bar.show_percentage = false
	energy_bar.custom_minimum_size = Vector2(180, 12)
	energy_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	energy_bar.add_theme_stylebox_override("background", _meter_style(Color("#18332f")))
	energy_bar.add_theme_stylebox_override("fill", _meter_style(Color("#68d99b")))
	energy_meter.add_child(energy_bar)

	var progress_box := VBoxContainer.new()
	progress_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	progress_box.add_theme_constant_override("separation", 2)
	status_row.add_child(progress_box)
	progress_box.add_child(_make_label("PROGRES PERTEMPURAN", 10, Color("#c9d9f4")))
	wave_progress_label = _make_label("Musuh 0/4  •  Kalah 0  •  Akurasi 0%", 12, Color("#d2e5dc"))
	progress_box.add_child(wave_progress_label)

	var body := HBoxContainer.new()
	body.add_theme_constant_override("separation", 12)
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	outer.add_child(body)

	var arena_panel := PanelContainer.new()
	arena_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	arena_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	arena_panel.add_theme_stylebox_override("panel", _panel_style(Color("#173a32"), Color("#3d6d54"), 16, 7))
	body.add_child(arena_panel)

	arena = ArenaViewScript.new()
	arena.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	arena.size_flags_vertical = Control.SIZE_EXPAND_FILL
	arena.slot_clicked.connect(_on_slot_clicked)
	arena_panel.add_child(arena)

	var side_panel := PanelContainer.new()
	side_panel.custom_minimum_size = Vector2(310, 0)
	side_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	side_panel.add_theme_stylebox_override("panel", _panel_style(Color("#1a4140"), Color("#35675b"), 16, 12))
	body.add_child(side_panel)

	var side := VBoxContainer.new()
	side.add_theme_constant_override("separation", 7)
	side_panel.add_child(side)

	math_heading = _make_label("TANTANGAN MATEMATIKA", 15, Color("#a6e6b8"))
	side.add_child(math_heading)
	question_label = _make_label("12 + 8 = ?", 30, Color("#fff4d6"), HORIZONTAL_ALIGNMENT_CENTER)
	question_label.custom_minimum_size = Vector2(0, 48)
	side.add_child(question_label)
	reward_hint_label = _make_label("Jawaban benar memberi energi.", 11, Color("#9fbdb2"), HORIZONTAL_ALIGNMENT_CENTER)
	reward_hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	side.add_child(reward_hint_label)

	var answer_grid := GridContainer.new()
	answer_grid.columns = 2
	answer_grid.add_theme_constant_override("h_separation", 7)
	answer_grid.add_theme_constant_override("v_separation", 7)
	side.add_child(answer_grid)
	for index in range(4):
		var answer_button := _make_button("?", Vector2(0, 46), false)
		answer_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		answer_button.pressed.connect(_on_answer_pressed.bind(index))
		answer_buttons.append(answer_button)
		answer_grid.add_child(answer_button)

	feedback_label = _make_label("Jawab soal untuk memperoleh Math Energy.", 12, Color("#d2e5dc"))
	feedback_label.custom_minimum_size = Vector2(0, 36)
	feedback_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	side.add_child(feedback_label)

	var divider := HSeparator.new()
	side.add_child(divider)
	var guardian_heading := _make_label("PILIH MATH GUARDIAN", 15, Color("#a6e6b8"))
	side.add_child(guardian_heading)

	for guardian_type in guardian_button_types:
		var guardian_button := _make_button(str(GUARDIAN_DESCRIPTIONS[guardian_type]), Vector2(0, 42), false)
		guardian_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		guardian_button.add_theme_font_size_override("font_size", 12)
		guardian_button.pressed.connect(_select_guardian.bind(guardian_type))
		guardian_buttons.append(guardian_button)
		side.add_child(guardian_button)

	var guardian_help := _make_label("Pilih Guardian, lalu klik petak kosong. Plusy menghasilkan energi, Addy menembak, Shield menahan musuh.", 11, Color("#9fbdb2"))
	guardian_help.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	side.add_child(guardian_help)

	var footer := HBoxContainer.new()
	footer.add_theme_constant_override("separation", 10)
	outer.add_child(footer)
	var instruction := _make_label("1 / 2 / 3: PILIH GUARDIAN  •  ESC: JEDA", 11, Color("#9fbdb2"))
	instruction.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	footer.add_child(instruction)
	pause_button = _make_button("JEDA", Vector2(88, 34), false)
	pause_button.add_theme_font_size_override("font_size", 12)
	pause_button.pressed.connect(_toggle_pause)
	footer.add_child(pause_button)
	var menu_button := _make_button("MENU", Vector2(82, 34), false)
	menu_button.add_theme_font_size_override("font_size", 12)
	menu_button.pressed.connect(_return_to_menu)
	footer.add_child(menu_button)

func _difficulty_for_wave() -> String:
	if current_wave <= 1:
		return "mudah"
	if current_wave == 2:
		return "sedang"
	return "sulit"

func _new_question() -> void:
	current_question = QuestionGenerator.make_question(_difficulty_for_wave())
	question_label.text = "%d %s %d = ?" % [int(current_question["a"]), str(current_question["operator"]), int(current_question["b"])]
	math_heading.text = "TANTANGAN MATEMATIKA • %s" % str(current_question["difficulty"]).to_upper()
	reward_hint_label.text = "Jawaban benar: +%d energi • Combo tiap 3 benar: +10" % int(current_question["reward"])
	var options: Array = current_question["options"]
	for index in range(answer_buttons.size()):
		answer_buttons[index].text = str(options[index])
		answer_buttons[index].disabled = false

func _on_answer_pressed(index: int) -> void:
	if battle_finished or index < 0 or index >= answer_buttons.size():
		return
	var options: Array = current_question["options"]
	if index >= options.size():
		return
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
	if chosen == correct:
		correct_answers += 1
		combo += 1
		var reward: int = int(current_question["reward"])
		var combo_bonus: int = 10 if combo % 3 == 0 else 0
		var total_reward: int = reward + combo_bonus
		energy = mini(999, energy + total_reward)
		score += 100 + total_reward
		var combo_text: String = " Combo %d!" % combo if combo_bonus > 0 else ""
		feedback_label.text = "Benar! +%d energi.%s" % [total_reward, combo_text]
		feedback_label.add_theme_color_override("font_color", Color("#a6e6b8"))
		if is_instance_valid(arena):
			arena.add_visual_effect("reward", Vector2(arena.size.x * 0.5, 38.0), Color("#a6e6b8"), "+%d ENERGI" % total_reward)
	else:
		wrong_answers += 1
		combo = 0
		energy = mini(999, energy + 10)
		var explanation: String = "%d %s %d = %d" % [int(current_question["a"]), str(current_question["operator"]), int(current_question["b"]), correct]
		feedback_label.text = "Belum tepat. %s. +10 energi, tetap semangat!" % explanation
		feedback_label.add_theme_color_override("font_color", Color("#f2b4a8"))
		if is_instance_valid(arena):
			arena.add_visual_effect("reward", Vector2(arena.size.x * 0.5, 38.0), Color("#f2b4a8"), "JAWABAN: %d" % correct)
	_new_question()
	_refresh_hud()

func _select_guardian(guardian_type: String) -> void:
	if battle_finished or paused:
		return
	if energy < int(GUARDIAN_COSTS.get(guardian_type, 99999)) and selected_guardian != guardian_type:
		feedback_label.text = "Energi belum cukup. Butuh %d untuk %s." % [int(GUARDIAN_COSTS.get(guardian_type, 0)), guardian_type]
		feedback_label.add_theme_color_override("font_color", Color("#f2b4a8"))
		return
	if selected_guardian == guardian_type:
		selected_guardian = ""
		feedback_label.text = "Pilihan Guardian dibatalkan."
	else:
		selected_guardian = guardian_type
		feedback_label.text = "Dipilih: %s. Klik petak kosong di arena." % guardian_type
		feedback_label.add_theme_color_override("font_color", Color("#fff4d6"))
	_update_guardian_button_styles()
	_refresh_hud()

func _on_slot_clicked(lane: int, column: int) -> void:
	if battle_finished or paused:
		return
	if selected_guardian.is_empty():
		feedback_label.text = "Pilih Math Guardian terlebih dahulu."
		feedback_label.add_theme_color_override("font_color", Color("#fff4d6"))
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
		"energy_timer": 0.0
	})
	if is_instance_valid(arena):
		var placed_guardian: Dictionary = guardians[guardians.size() - 1]
		arena.add_visual_effect("spawn", arena.get_guardian_center(placed_guardian), Color("#a6e6b8"), "SIAP!")
	feedback_label.text = "%s berhasil ditempatkan!" % selected_guardian
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
	_new_question()
	feedback_label.text = "Wave %d dimulai! Lindungi Core Numeria." % current_wave
	feedback_label.add_theme_color_override("font_color", Color("#fff4d6"))
	if is_instance_valid(arena):
		arena.add_visual_effect("wave", Vector2(maxf(arena.size.x * 0.5, 320.0), 46.0), Color("#f5d57d"), "WAVE %d DIMULAI" % current_wave)

func _spawn_enemy() -> void:
	var enemy_type: String = "Error Blob"
	if current_wave == 2 and spawned_this_wave % 3 == 2:
		enemy_type = "Minus Monster"
	elif current_wave >= 3:
		if spawned_this_wave % 4 == 3:
			enemy_type = "Calculator Bug"
		elif spawned_this_wave % 3 == 2:
			enemy_type = "Minus Monster"

	var hp: int = 50
	var speed: float = 36.0
	var core_damage: int = 20
	if enemy_type == "Minus Monster":
		hp = 100
		speed = 28.0
		core_damage = 20
	elif enemy_type == "Calculator Bug":
		hp = 70
		speed = 57.0
		core_damage = 15

	var lane: int = randi_range(0, 2)
	enemies.append({
		"id": next_enemy_id,
		"type": enemy_type,
		"lane": lane,
		"x": maxf(arena.size.x - 30.0, 400.0),
		"hp": hp,
		"max_hp": hp,
		"speed": speed,
		"core_damage": core_damage,
		"attack_timer": 0.0
	})
	next_enemy_id += 1
	spawned_this_wave += 1

func _update_guardians(delta: float) -> void:
	for index in range(guardians.size()):
		var guardian: Dictionary = guardians[index]
		var guardian_type: String = str(guardian["type"])
		if guardian_type == "Plusy":
			guardian["energy_timer"] = float(guardian.get("energy_timer", 0.0)) + delta
			if float(guardian["energy_timer"]) >= 5.0:
				guardian["energy_timer"] = float(guardian["energy_timer"]) - 5.0
				energy = mini(999, energy + 5)
				if is_instance_valid(arena):
					arena.add_visual_effect("reward", arena.get_guardian_center(guardian), Color("#a6e6b8"), "+5")
		elif guardian_type == "Addy Cannon":
			guardian["cooldown"] = float(guardian.get("cooldown", 0.0)) - delta
			if float(guardian["cooldown"]) <= 0.0:
				var target_index: int = _find_target_index(guardian)
				if target_index >= 0:
					var target: Dictionary = enemies[target_index]
					var guardian_center: Vector2 = arena.get_guardian_center(guardian)
					projectiles.append({
						"lane": int(guardian["lane"]),
						"x": guardian_center.x + 18.0,
						"y": arena.get_lane_center(int(guardian["lane"])) - 7.0,
						"target_id": int(target["id"]),
						"speed": 430.0,
						"damage": 10
					})
					arena.add_visual_effect("muzzle", guardian_center + Vector2(23.0, -5.0), Color("#a8e9ff"))
					guardian["cooldown"] = 0.9
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
			target["hp"] = int(target["hp"]) - damage
			enemies[target_index] = target
			if is_instance_valid(arena):
				arena.add_visual_effect("hit", Vector2(float(target["x"]), arena.get_lane_center(int(target["lane"]))), Color("#ffd18c"), "-%d" % damage)
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
		if int(enemy["hp"]) <= 0:
			if is_instance_valid(arena):
				arena.add_visual_effect("defeat", Vector2(float(enemy["x"]), arena.get_lane_center(int(enemy["lane"]))), Color("#a6e6b8"), "+20")
			enemies.remove_at(index)
			defeated_enemies += 1
			score += 20
			continue

		var shield_index: int = _find_blocking_shield(enemy)
		if shield_index >= 0:
			enemy["attack_timer"] = float(enemy.get("attack_timer", 0.0)) + delta
			if float(enemy["attack_timer"]) >= 1.0:
				enemy["attack_timer"] = float(enemy["attack_timer"]) - 1.0
				var shield: Dictionary = guardians[shield_index]
				shield["hp"] = int(shield.get("hp", 300)) - 15
				if is_instance_valid(arena):
					arena.add_visual_effect("hit", arena.get_guardian_center(shield), Color("#f2b4a8"), "-15")
				if int(shield["hp"]) <= 0:
					if is_instance_valid(arena):
						arena.add_visual_effect("defeat", arena.get_guardian_center(shield), Color("#f2b4a8"), "HANCUR")
					guardians.remove_at(shield_index)
					feedback_label.text = "Shield Cube hancur. Coba lindungi jalur ini lagi."
				else:
					guardians[shield_index] = shield
			enemies[index] = enemy
		else:
			enemy["x"] = float(enemy["x"]) - float(enemy["speed"]) * delta
			if float(enemy["x"]) <= 18.0:
				var core_damage_amount: int = int(enemy.get("core_damage", 20))
				core_hp -= core_damage_amount
				if is_instance_valid(arena):
					arena.add_visual_effect("hit", Vector2(26.0, arena.get_lane_center(int(enemy["lane"]))), Color("#f2b4a8"), "CORE -%d" % core_damage_amount)
				if str(enemy["type"]) == "Minus Monster":
					energy = maxi(0, energy - 15)
					feedback_label.text = "Minus Monster menyerang! Core -20, energi -15."
				else:
					feedback_label.text = "Musuh menembus pertahanan! Core menerima kerusakan."
				feedback_label.add_theme_color_override("font_color", Color("#f2b4a8"))
				enemies.remove_at(index)
				if core_hp <= 0:
					core_hp = 0
					_finish_battle(false)
					return
			else:
				enemies[index] = enemy

func _find_blocking_shield(enemy: Dictionary) -> int:
	for index in range(guardians.size()):
		var guardian: Dictionary = guardians[index]
		if str(guardian["type"]) != "Shield Cube" or int(guardian["lane"]) != int(enemy["lane"]):
			continue
		var guardian_x: float = arena.get_guardian_center(guardian).x
		if float(enemy["x"]) <= guardian_x + 24.0 and float(enemy["x"]) >= guardian_x - 24.0:
			return index
	return -1

func _refresh_hud() -> void:
	if is_instance_valid(energy_label):
		energy_label.text = "ENERGI  %d" % energy
		core_label.text = "CORE  %d/100" % core_hp
		wave_label.text = "WAVE  %d/3" % max(current_wave, 1)
		score_label.text = "SKOR  %d" % score
	if is_instance_valid(core_bar):
		core_bar.value = core_hp
	if is_instance_valid(energy_bar):
		energy_bar.value = energy
	if is_instance_valid(wave_progress_label):
		var accuracy: int = roundi(float(correct_answers) / float(total_questions) * 100.0) if total_questions > 0 else 0
		wave_progress_label.text = "Musuh %d/%d  •  Kalah %d  •  Akurasi %d%%" % [spawned_this_wave, spawn_target, defeated_enemies, accuracy]
	if is_instance_valid(arena):
		arena.guardians = guardians
		arena.enemies = enemies
		arena.projectiles = projectiles
		arena.placement_enabled = not selected_guardian.is_empty() and not paused and not battle_finished
		arena.queue_redraw()
	_update_guardian_button_styles()

func _update_guardian_button_styles() -> void:
	for index in range(guardian_buttons.size()):
		var guardian_type: String = guardian_button_types[index]
		var is_selected: bool = guardian_type == selected_guardian
		var can_afford: bool = energy >= int(GUARDIAN_COSTS[guardian_type])
		guardian_buttons[index].disabled = not can_afford or paused or battle_finished
		guardian_buttons[index].add_theme_stylebox_override("normal", _button_style(Color("#a6e6b8") if is_selected else Color("#28564c"), Color("#d9ffe0") if is_selected else Color("#4d7b68"), 9, 7))
		guardian_buttons[index].add_theme_color_override("font_color", Color("#102b32") if is_selected else Color("#e5f1e9"))

func _toggle_pause() -> void:
	if battle_finished:
		return
	paused = not paused
	pause_button.text = "LANJUT" if paused else "JEDA"
	feedback_label.text = "Permainan dijeda." if paused else "Permainan dilanjutkan."
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
	overlay.color = Color(0.02, 0.07, 0.07, 0.84)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(overlay)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(540, 360)
	panel.add_theme_stylebox_override("panel", _panel_style(Color("#1a4140"), Color("#8ccca2"), 20, 22))
	center.add_child(panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 11)
	panel.add_child(content)
	var title_text: String = "NUMERIA SELAMAT!" if victory else "CORE NUMERIA RUNTUH"
	var detail_text: String = "Hebat! Kamu berhasil melewati semua wave." if victory else "Coba susun Guardian pada jalur yang berbeda dan jawab soal untuk memperoleh energi."
	var title := _make_label(title_text, 26, Color("#fff4d6"), HORIZONTAL_ALIGNMENT_CENTER)
	content.add_child(title)
	var detail := _make_label(detail_text, 14, Color("#c2d9d3"), HORIZONTAL_ALIGNMENT_CENTER)
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(detail)
	var accuracy: int = roundi(float(correct_answers) / float(maxi(total_questions, 1)) * 100.0)
	var stats := _make_label("Skor %d  •  Musuh dikalahkan %d\nBenar %d  •  Salah %d  •  Akurasi %d%%" % [score, defeated_enemies, correct_answers, wrong_answers, accuracy], 13, Color("#a6e6b8"), HORIZONTAL_ALIGNMENT_CENTER)
	stats.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stats.custom_minimum_size = Vector2(0, 42)
	content.add_child(stats)
	var review_button := _make_button("LIHAT PEMBAHASAN SOAL", Vector2(0, 36), false)
	review_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_child(review_button)
	var review_label := _make_label(_build_review_text(), 12, Color("#d2e5dc"), HORIZONTAL_ALIGNMENT_CENTER)
	review_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	review_label.custom_minimum_size = Vector2(0, 96)
	review_label.visible = false
	content.add_child(review_label)
	review_button.pressed.connect(func() -> void:
		review_label.visible = not review_label.visible
		review_button.text = "SEMBUNYIKAN PEMBAHASAN" if review_label.visible else "LIHAT PEMBAHASAN SOAL"
	)
	var replay := _make_button("MAIN LAGI", Vector2(0, 44), true)
	replay.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	replay.pressed.connect(func() -> void: get_tree().reload_current_scene())
	content.add_child(replay)
	var menu := _make_button("MENU UTAMA", Vector2(0, 40), false)
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
	button.add_theme_color_override("font_color", Color("#102b32") if primary else Color("#e5f1e9"))
	button.add_theme_color_override("font_hover_color", Color("#102b32") if primary else Color("#ffffff"))
	button.add_theme_stylebox_override("normal", _button_style(Color("#a6e6b8") if primary else Color("#28564c"), Color("#c6f2d2") if primary else Color("#4d7b68"), 10, 8))
	button.add_theme_stylebox_override("hover", _button_style(Color("#c1f2cb") if primary else Color("#36705d"), Color("#e0ffe5") if primary else Color("#76a88d"), 10, 8))
	button.add_theme_stylebox_override("pressed", _button_style(Color("#81c99b") if primary else Color("#1c423a"), Color("#a6e6b8") if primary else Color("#4d7b68"), 10, 8))
	button.add_theme_stylebox_override("focus", _button_style(Color(0.0, 0.0, 0.0, 0.0), Color("#fff4d6"), 10, 8))
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
	style.set_corner_radius_all(radius)
	style.set_content_margin_all(padding)
	return style
