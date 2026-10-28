extends Control

const BATTLE_SCENE: String = "res://scenes/battle.tscn"
var help_overlay: Control
var level_overlay: Control
var level_list_container: GridContainer
var selected_world_id: int = 1

func _ready() -> void:
	var unlocked_data: Dictionary = LevelProgress.get_level_data(LevelProgress.highest_unlocked_level)
	selected_world_id = clampi(int(unlocked_data.get("world_id", 1)), 1, 3)
	_build_ui()

func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color("#1c251b")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var lower_glow := ColorRect.new()
	lower_glow.color = Color("#31472d")
	lower_glow.anchor_left = 0.0
	lower_glow.anchor_top = 0.72
	lower_glow.anchor_right = 1.0
	lower_glow.anchor_bottom = 1.0
	lower_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(lower_glow)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.add_theme_constant_override("margin_left", 18)
	center.add_theme_constant_override("margin_right", 18)
	add_child(center)

	var column := VBoxContainer.new()
	column.custom_minimum_size = Vector2(minf(560.0, maxf(300.0, get_viewport_rect().size.x - 36.0)), 0)
	column.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	column.add_theme_constant_override("separation", 10)
	center.add_child(column)

	var eyebrow := _make_label("DUNIA NUMERIA", 15, Color("#d3ad5b"), HORIZONTAL_ALIGNMENT_CENTER)
	column.add_child(eyebrow)

	var title := _make_label("MATH-ADVENTURE", 42, Color("#f1e4c7"), HORIZONTAL_ALIGNMENT_CENTER)
	column.add_child(title)

	var subtitle := _make_label("Hitung. Bertahan. Menang.", 17, Color("#d9d0a5"), HORIZONTAL_ALIGNMENT_CENTER)
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(subtitle)

	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", _panel_style(Color("#eee2c4"), Color("#171a13"), 5, 18))
	column.add_child(card)

	var card_content := VBoxContainer.new()
	card_content.add_theme_constant_override("separation", 9)
	card.add_child(card_content)

	var start_button := _make_button("PILIH LEVEL", Vector2(0, 60), true)
	start_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	start_button.pressed.connect(_show_level_select)
	card_content.add_child(start_button)

	var secondary_row := HBoxContainer.new()
	secondary_row.add_theme_constant_override("separation", 8)
	card_content.add_child(secondary_row)
	var help_button := _make_button("CARA MAIN", Vector2(0, 46), false)
	help_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	help_button.pressed.connect(_show_help)
	secondary_row.add_child(help_button)
	var exit_button := _make_button("KELUAR", Vector2(110, 46), false)
	exit_button.pressed.connect(_exit_game)
	secondary_row.add_child(exit_button)

	var save_data := ConfigFile.new()
	save_data.load("user://math_adventure.cfg")
	var best_score: int = int(save_data.get_value("stats", "best_score", 0))
	var record := _make_label("REKOR %d" % best_score, 12, Color("#e8c36f"), HORIZONTAL_ALIGNMENT_CENTER)
	column.add_child(record)
	var progress_summary := _make_label("LEVEL TERBUKA %d/40  •  ★ %d/120" % [int(LevelProgress.highest_unlocked_level), int(LevelProgress.get_total_stars())], 12, Color("#e8c36f"), HORIZONTAL_ALIGNMENT_CENTER)
	column.add_child(progress_summary)


func _show_level_select() -> void:
	if is_instance_valid(level_overlay):
		level_overlay.queue_free()
	level_overlay = ColorRect.new()
	level_overlay.color = Color(0.02, 0.05, 0.03, 0.90)
	level_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	level_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(level_overlay)

	var viewport_size: Vector2 = get_viewport_rect().size
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	level_overlay.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(minf(760.0, maxf(280.0, viewport_size.x - 24.0)), minf(520.0, maxf(340.0, viewport_size.y - 24.0)))
	panel.add_theme_stylebox_override("panel", _panel_style(Color("#eee2c4"), Color("#171a13"), 5, 14))
	center.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	panel.add_child(content)

	# Hanya satu tutorial untuk seluruh permainan, bisa dibuka dari peta mana pun.
	var top_row := HBoxContainer.new()
	top_row.add_theme_constant_override("separation", 8)
	content.add_child(top_row)
	var tutorial_button := _make_button("TUTORIAL", Vector2(126, 42), true)
	tutorial_button.add_theme_font_size_override("font_size", 13)
	tutorial_button.pressed.connect(_start_selected_level.bind(1))
	top_row.add_child(tutorial_button)
	var top_spacer := Control.new()
	top_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_row.add_child(top_spacer)
	var close_button := _make_button("×", Vector2(42, 42), false)
	close_button.add_theme_font_size_override("font_size", 22)
	close_button.pressed.connect(_close_level_select)
	top_row.add_child(close_button)

	# Nama map saja; tanpa jumlah level, kelas, atau deskripsi tambahan.
	var world_row := HBoxContainer.new()
	world_row.add_theme_constant_override("separation", 7)
	content.add_child(world_row)
	var map_names: Array[String] = ["ADDITION\nFOREST", "MULTIPLICATION\nDESERT", "FRACTION\nCASTLE"]
	for world_index in range(3):
		var world_id: int = world_index + 1
		var world_button := _make_button(map_names[world_index], Vector2(0, 54), world_id == selected_world_id)
		world_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		world_button.add_theme_font_size_override("font_size", 11)
		world_button.pressed.connect(_select_world.bind(world_id))
		world_row.add_child(world_button)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	content.add_child(scroll)

	var grid_center := CenterContainer.new()
	grid_center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid_center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.add_child(grid_center)
	level_list_container = GridContainer.new()
	level_list_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	level_list_container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	level_list_container.add_theme_constant_override("h_separation", 9)
	level_list_container.add_theme_constant_override("v_separation", 9)
	grid_center.add_child(level_list_container)
	_render_level_grid()

func _select_world(world_id: int) -> void:
	selected_world_id = clampi(world_id, 1, 3)
	_show_level_select()

func _render_level_grid() -> void:
	if not is_instance_valid(level_list_container):
		return
	for child in level_list_container.get_children():
		child.queue_free()

	var viewport_width: float = get_viewport_rect().size.x
	var columns: int = 6 if viewport_width >= 800.0 else (5 if viewport_width >= 520.0 else 4)
	var button_size: float = 64.0 if viewport_width >= 520.0 else 54.0
	level_list_container.columns = columns

	for entry in LevelProgress.get_world_levels(selected_world_id):
		var level_id: int = int(entry.get("id", 1))
		var local_level: int = int(entry.get("local_level", 1))
		var unlocked: bool = LevelProgress.is_level_unlocked(level_id)
		var is_current: bool = level_id == LevelProgress.highest_unlocked_level
		var level_button := Button.new()
		level_button.text = str(local_level)
		level_button.custom_minimum_size = Vector2(button_size, button_size)
		level_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		level_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		level_button.add_theme_font_size_override("font_size", 20)
		level_button.tooltip_text = "Level %02d" % local_level
		level_button.disabled = not unlocked
		var fill_color: Color = Color("#d3ad5b") if is_current else Color("#536943")
		var text_color: Color = Color("#171a13") if is_current else Color("#f4e8c9")
		if not unlocked:
			fill_color = Color("#c7c0ab")
			text_color = Color("#898573")
		level_button.add_theme_color_override("font_color", text_color)
		level_button.add_theme_color_override("font_hover_color", Color("#171a13"))
		level_button.add_theme_color_override("font_disabled_color", text_color)
		level_button.add_theme_stylebox_override("normal", _panel_style(fill_color, Color("#171a13"), 4, 0))
		level_button.add_theme_stylebox_override("hover", _panel_style(Color("#e4c779"), Color("#171a13"), 4, 0))
		level_button.add_theme_stylebox_override("pressed", _panel_style(Color("#b78e42"), Color("#171a13"), 4, 0))
		level_button.add_theme_stylebox_override("disabled", _panel_style(fill_color, Color("#b0a78e"), 4, 0))
		if unlocked:
			level_button.pressed.connect(_start_selected_level.bind(level_id))
		level_list_container.add_child(level_button)

func _start_selected_level(level_id: int) -> void:
	if not LevelProgress.select_level(level_id):
		return
	_close_level_select()
	_start_battle()

func _close_level_select() -> void:
	if is_instance_valid(level_overlay):
		level_overlay.queue_free()
	level_overlay = null
	level_list_container = null

func _show_help() -> void:
	if is_instance_valid(help_overlay):
		help_overlay.queue_free()

	help_overlay = ColorRect.new()
	help_overlay.color = Color(0.02, 0.07, 0.07, 0.86)
	help_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	help_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(help_overlay)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	help_overlay.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(minf(520.0, maxf(300.0, get_viewport_rect().size.x - 36.0)), 0)
	panel.add_theme_stylebox_override("panel", _panel_style(Color("#eee2c4"), Color("#171a13"), 5, 24))
	center.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	panel.add_child(content)
	content.add_child(_make_label("CARA BERMAIN", 24, Color("#171a13"), HORIZONTAL_ALIGNMENT_CENTER))
	var instructions := _make_label("1. Seret kartu Guardian ke petak kosong, atau ketuk kartu lalu petak.\n2. Ketuk energi untuk menjawab soal dan mendapat energi.\n3. Plusy menghasilkan energi, Addy menyerang, Shield menahan musuh.\n4. Jaga Core dan selesaikan semua wave pada level.", 15, Color("#4c4b38"))
	instructions.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(instructions)
	var close_button := _make_button("MENGERTI", Vector2(0, 44), true)
	close_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	close_button.pressed.connect(_close_help)
	content.add_child(close_button)

func _close_help() -> void:
	if is_instance_valid(help_overlay):
		help_overlay.queue_free()
	help_overlay = null

func _start_battle() -> void:
	get_tree().change_scene_to_file(BATTLE_SCENE)

func _exit_game() -> void:
	get_tree().quit()

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
	button.add_theme_font_size_override("font_size", 17 if primary else 13)
	button.add_theme_color_override("font_color", Color("#171a13") if primary else Color("#f4e8c9"))
	button.add_theme_color_override("font_hover_color", Color("#171a13") if primary else Color("#fff9e8"))
	button.add_theme_stylebox_override("normal", _panel_style(Color("#d3ad5b") if primary else Color("#31482f"), Color("#171a13"), 5, 10))
	button.add_theme_stylebox_override("hover", _panel_style(Color("#e4c779") if primary else Color("#455f3d"), Color("#171a13"), 5, 10))
	button.add_theme_stylebox_override("pressed", _panel_style(Color("#b78e42") if primary else Color("#223521"), Color("#171a13"), 5, 10))
	button.add_theme_stylebox_override("focus", _panel_style(Color(0.0, 0.0, 0.0, 0.0), Color("#e8c36f"), 5, 10))
	return button

func _panel_style(background: Color, border: Color, radius: int, padding: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(mini(radius, 5))
	style.set_border_width_all(2)
	style.set_content_margin_all(padding)
	return style
