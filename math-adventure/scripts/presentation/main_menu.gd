extends Control

const BATTLE_SCENE: String = "res://scenes/battle.tscn"

func _ready() -> void:
	_build_ui()

func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color("#102b32")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var glow := ColorRect.new()
	glow.color = Color("#173d3c")
	glow.anchor_left = 0.0
	glow.anchor_top = 0.68
	glow.anchor_right = 1.0
	glow.anchor_bottom = 1.0
	glow.offset_top = 0.0
	glow.offset_bottom = 0.0
	add_child(glow)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 34)
	margin.add_theme_constant_override("margin_right", 34)
	margin.add_theme_constant_override("margin_top", 26)
	margin.add_theme_constant_override("margin_bottom", 26)
	add_child(margin)

	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(center)

	var column := VBoxContainer.new()
	column.custom_minimum_size = Vector2(650, 0)
	column.add_theme_constant_override("separation", 14)
	center.add_child(column)

	var eyebrow := _make_label("PETUALANGAN EDUKASI • DUNIA NUMERIA", 15, Color("#9fe3bd"), HORIZONTAL_ALIGNMENT_CENTER)
	column.add_child(eyebrow)

	var title := _make_label("MATH-ADVENTURE", 48, Color("#fff4d6"), HORIZONTAL_ALIGNMENT_CENTER)
	title.add_theme_font_size_override("font_size", 48)
	column.add_child(title)

	var subtitle := _make_label("Berhitung, kumpulkan energi, lindungi Numeria!", 20, Color("#c2d9d3"), HORIZONTAL_ALIGNMENT_CENTER)
	column.add_child(subtitle)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 8)
	column.add_child(spacer)

	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", _panel_style(Color("#1a4140"), Color("#35675b"), 22, 26))
	column.add_child(card)

	var card_content := VBoxContainer.new()
	card_content.add_theme_constant_override("separation", 12)
	card.add_child(card_content)

	var card_title := _make_label("MISI: SELAMATKAN CORE NUMERIA", 19, Color("#fff4d6"), HORIZONTAL_ALIGNMENT_CENTER)
	card_content.add_child(card_title)

	var description := _make_label("Jawab soal matematika untuk mendapatkan Math Energy. Gunakan energi untuk menempatkan Guardian dan menghentikan gelombang Math Error.", 16, Color("#d2e5dc"), HORIZONTAL_ALIGNMENT_CENTER)
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	card_content.add_child(description)

	var start_button := _make_button("MULAI PETUALANGAN", Vector2(0, 58), true)
	start_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	start_button.pressed.connect(_start_battle)
	card_content.add_child(start_button)

	var hint := _make_label("3 jalur  •  3 wave  •  Penjumlahan & pengurangan", 14, Color("#9fbdb2"), HORIZONTAL_ALIGNMENT_CENTER)
	column.add_child(hint)

	var version := _make_label("PROTOTIPE MVP • GODOT 4", 11, Color("#70968c"), HORIZONTAL_ALIGNMENT_CENTER)
	column.add_child(version)

func _start_battle() -> void:
	get_tree().change_scene_to_file(BATTLE_SCENE)

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
	button.add_theme_font_size_override("font_size", 18 if primary else 15)
	button.add_theme_color_override("font_color", Color("#102b32") if primary else Color("#e5f1e9"))
	button.add_theme_color_override("font_hover_color", Color("#102b32"))
	var normal := _panel_style(Color("#a6e6b8") if primary else Color("#28564c"), Color("#c6f2d2") if primary else Color("#4d7b68"), 13, 12)
	var hover := _panel_style(Color("#c1f2cb") if primary else Color("#36705d"), Color("#e0ffe5") if primary else Color("#76a88d"), 13, 12)
	var pressed := _panel_style(Color("#81c99b") if primary else Color("#1c423a"), Color("#a6e6b8") if primary else Color("#4d7b68"), 13, 12)
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("focus", _panel_style(Color(0, 0, 0, 0), Color("#fff4d6"), 13, 12))
	return button

func _panel_style(background: Color, border: Color, radius: int, padding: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(radius)
	style.set_content_margin_all(padding)
	return style
