extends Control

const BATTLE_SCENE: String = "res://scenes/battle.tscn"
var help_overlay: Control

func _ready() -> void:
	_build_ui()

func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color("#102b32")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var lower_glow := ColorRect.new()
	lower_glow.color = Color("#173d3c")
	lower_glow.anchor_left = 0.0
	lower_glow.anchor_top = 0.68
	lower_glow.anchor_right = 1.0
	lower_glow.anchor_bottom = 1.0
	lower_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(lower_glow)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 28)
	margin.add_theme_constant_override("margin_right", 28)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	add_child(margin)

	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(center)

	var column := VBoxContainer.new()
	column.custom_minimum_size = Vector2(650, 0)
	column.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	column.add_theme_constant_override("separation", 12)
	center.add_child(column)

	var eyebrow := _make_label("PETUALANGAN EDUKASI • DUNIA NUMERIA", 15, Color("#9fe3bd"), HORIZONTAL_ALIGNMENT_CENTER)
	column.add_child(eyebrow)

	var title := _make_label("MATH-ADVENTURE", 46, Color("#fff4d6"), HORIZONTAL_ALIGNMENT_CENTER)
	title.add_theme_font_size_override("font_size", 46)
	column.add_child(title)

	var subtitle := _make_label("Berhitung, kumpulkan energi, lindungi Numeria!", 19, Color("#c2d9d3"), HORIZONTAL_ALIGNMENT_CENTER)
	column.add_child(subtitle)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 5)
	column.add_child(spacer)

	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", _panel_style(Color("#1a4140"), Color("#35675b"), 22, 24))
	column.add_child(card)

	var card_content := VBoxContainer.new()
	card_content.add_theme_constant_override("separation", 11)
	card.add_child(card_content)

	var card_title := _make_label("MISI: SELAMATKAN CORE NUMERIA", 18, Color("#fff4d6"), HORIZONTAL_ALIGNMENT_CENTER)
	card_content.add_child(card_title)

	var description := _make_label("Jawab soal matematika untuk mendapatkan Math Energy. Gunakan energi untuk menempatkan Guardian dan menghentikan gelombang Math Error.", 15, Color("#d2e5dc"), HORIZONTAL_ALIGNMENT_CENTER)
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	card_content.add_child(description)

	var start_button := _make_button("MULAI PETUALANGAN", Vector2(0, 56), true)
	start_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	start_button.pressed.connect(_start_battle)
	card_content.add_child(start_button)

	var secondary_row := HBoxContainer.new()
	secondary_row.add_theme_constant_override("separation", 9)
	card_content.add_child(secondary_row)
	var help_button := _make_button("CARA BERMAIN", Vector2(0, 42), false)
	help_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	help_button.pressed.connect(_show_help)
	secondary_row.add_child(help_button)
	var exit_button := _make_button("KELUAR", Vector2(110, 42), false)
	exit_button.pressed.connect(_exit_game)
	secondary_row.add_child(exit_button)

	var hint := _make_label("3 jalur  •  3 wave  •  Penjumlahan & pengurangan", 13, Color("#9fbdb2"), HORIZONTAL_ALIGNMENT_CENTER)
	column.add_child(hint)

	var save_data := ConfigFile.new()
	save_data.load("user://math_adventure.cfg")
	var best_score: int = int(save_data.get_value("stats", "best_score", 0))
	var record := _make_label("REKOR TERBAIK: %d" % best_score, 12, Color("#a6e6b8"), HORIZONTAL_ALIGNMENT_CENTER)
	column.add_child(record)

	var version := _make_label("PROTOTIPE 0.4 • GODOT 4.7.2", 10, Color("#70968c"), HORIZONTAL_ALIGNMENT_CENTER)
	column.add_child(version)

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
	panel.custom_minimum_size = Vector2(520, 0)
	panel.add_theme_stylebox_override("panel", _panel_style(Color("#1a4140"), Color("#8ccca2"), 20, 24))
	center.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	panel.add_child(content)
	content.add_child(_make_label("CARA BERMAIN", 24, Color("#fff4d6"), HORIZONTAL_ALIGNMENT_CENTER))
	var instructions := _make_label("1. Pilih jawaban matematika untuk mendapatkan Math Energy.\n2. Pilih Plusy, Addy Cannon, atau Shield Cube.\n3. Klik petak kosong di salah satu dari tiga jalur.\n4. Plusy menghasilkan energi, Addy menembakkan proyektil, dan Shield menahan musuh.\n5. Lawan tiga wave dan jaga Core Numeria tetap berdiri.\n\nJawaban benar memberi energi lebih banyak. Soal akan meningkat kesulitannya pada setiap wave.", 15, Color("#d2e5dc"))
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
	button.add_theme_color_override("font_color", Color("#102b32") if primary else Color("#e5f1e9"))
	button.add_theme_color_override("font_hover_color", Color("#102b32") if primary else Color("#ffffff"))
	button.add_theme_stylebox_override("normal", _panel_style(Color("#a6e6b8") if primary else Color("#28564c"), Color("#c6f2d2") if primary else Color("#4d7b68"), 12, 10))
	button.add_theme_stylebox_override("hover", _panel_style(Color("#c1f2cb") if primary else Color("#36705d"), Color("#e0ffe5") if primary else Color("#76a88d"), 12, 10))
	button.add_theme_stylebox_override("pressed", _panel_style(Color("#81c99b") if primary else Color("#1c423a"), Color("#a6e6b8") if primary else Color("#4d7b68"), 12, 10))
	button.add_theme_stylebox_override("focus", _panel_style(Color(0.0, 0.0, 0.0, 0.0), Color("#fff4d6"), 12, 10))
	return button

func _panel_style(background: Color, border: Color, radius: int, padding: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(radius)
	style.set_content_margin_all(padding)
	return style
