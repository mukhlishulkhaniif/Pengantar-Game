extends Control
## Arena bergaya kebun kartun untuk Math-Adventure.
## Memakai PNG orisinal jika tersedia, dengan gambar prosedural sebagai fallback selama aset disiapkan.

signal slot_clicked(lane: int, column: int)

const LANE_COUNT: int = 5
const COLUMN_COUNT: int = 9
const GRID_TOP_MARGIN: float = 8.0
const GRID_BOTTOM_MARGIN: float = 8.0
const BACKGROUND_TEXTURE_PATH: String = "res://assets/backgrounds/addition_forest_bg.png"
const GUARDIAN_TEXTURE_PATHS: Dictionary = {
	"Plusy": "res://assets/characters/plusy.png",
	"Addy Cannon": "res://assets/characters/addy_cannon.png",
	"Shield Cube": "res://assets/characters/shield_cube.png"
}
const ENEMY_TEXTURE_PATHS: Dictionary = {
	"Error Blob": "res://assets/characters/error_blob.png",
	"Minus Monster": "res://assets/characters/minus_monster.png",
	"Calculator Bug": "res://assets/characters/calculator_bug.png"
}

var guardians: Array = []
var enemies: Array = []
var projectiles: Array = []
var placement_enabled: bool = false
var visual_time: float = 0.0
var hovered_cell: Vector2i = Vector2i(-1, -1)
var drag_preview_active: bool = false
var drag_guardian_type: String = ""
var drag_position: Vector2 = Vector2.ZERO
var visual_effects: Array[Dictionary] = []
var background_texture: Texture2D
var guardian_textures: Dictionary = {}
var enemy_textures: Dictionary = {}

func _ready() -> void:
	_load_optional_art_assets()
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = Vector2(620, 420)
	mouse_exited.connect(_on_mouse_exited)

func _load_optional_art_assets() -> void:
	# PNG akan dibuat sebagai aset orisinal pada tahap art. Selama file belum ada,
	# prototipe tetap memakai ilustrasi prosedural agar scene tetap bisa dijalankan.
	if ResourceLoader.exists(BACKGROUND_TEXTURE_PATH):
		background_texture = load(BACKGROUND_TEXTURE_PATH) as Texture2D
	for guardian_type in GUARDIAN_TEXTURE_PATHS:
		var guardian_path: String = str(GUARDIAN_TEXTURE_PATHS[guardian_type])
		if ResourceLoader.exists(guardian_path):
			var guardian_texture := load(guardian_path) as Texture2D
			if guardian_texture != null:
				guardian_textures[guardian_type] = guardian_texture
	for enemy_type in ENEMY_TEXTURE_PATHS:
		var enemy_path: String = str(ENEMY_TEXTURE_PATHS[enemy_type])
		if ResourceLoader.exists(enemy_path):
			var enemy_texture := load(enemy_path) as Texture2D
			if enemy_texture != null:
				enemy_textures[enemy_type] = enemy_texture

func _process(delta: float) -> void:
	visual_time += delta
	for index in range(visual_effects.size() - 1, -1, -1):
		var effect: Dictionary = visual_effects[index]
		effect["life"] = float(effect.get("life", 0.0)) - delta
		if float(effect["life"]) <= 0.0:
			visual_effects.remove_at(index)
		else:
			var position: Vector2 = effect.get("position", Vector2.ZERO)
			position.y -= 16.0 * delta
			effect["position"] = position
			visual_effects[index] = effect
	if not guardians.is_empty() or not enemies.is_empty() or not projectiles.is_empty() or not visual_effects.is_empty() or drag_preview_active:
		queue_redraw()

func add_visual_effect(kind: String, position: Vector2, color: Color, text: String = "") -> void:
	var duration: float = 0.48
	if kind == "wave":
		duration = 0.82
	elif kind == "reward":
		duration = 0.66
	visual_effects.append({
		"kind": kind,
		"position": position,
		"color": color,
		"text": text,
		"life": duration,
		"max_life": duration
	})
	if visual_effects.size() > 40:
		visual_effects.pop_front()
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("#1c251b"), true)
	_draw_garden_background()
	_draw_core_gate()

	for guardian in guardians:
		_draw_guardian(guardian)
	for enemy in enemies:
		_draw_enemy(enemy)
	for projectile in projectiles:
		_draw_projectile(projectile)
	for effect in visual_effects:
		_draw_visual_effect(effect)

	if drag_preview_active:
		_draw_drag_preview()

func _draw_garden_background() -> void:
	if background_texture != null:
		draw_texture_rect(background_texture, Rect2(Vector2.ZERO, size), false)
		_draw_ink_grid_overlay()
		return

	var grid: Rect2 = _grid_rect()
	var cell_width: float = grid.size.x / float(COLUMN_COUNT)
	var lane_height: float = grid.size.y / float(LANE_COUNT)

	# Bingkai tanah dan garis tepi seperti papan kebun.
	draw_rect(grid.grow(5.0), Color("#171a13"), true)
	draw_rect(grid.grow(2.0), Color("#b38d4b"), true)
	draw_rect(grid, Color("#344c2c"), true)

	for lane in range(LANE_COUNT):
		var lane_rect := Rect2(grid.position.x, grid.position.y + float(lane) * lane_height, grid.size.x, lane_height)
		var lane_color: Color = Color("#506b3d") if lane % 2 == 0 else Color("#455f35")
		draw_rect(lane_rect, lane_color, true)

		for column in range(COLUMN_COUNT):
			var cell_rect := Rect2(grid.position.x + float(column) * cell_width, lane_rect.position.y, cell_width, lane_height)
			var cell_color: Color = Color(0.72, 0.96, 0.58, 0.055) if (lane + column) % 2 == 0 else Color(0.02, 0.14, 0.04, 0.045)
			draw_rect(cell_rect, cell_color, true)

			# Tambalan rumput dan garis rumput memakai posisi deterministik agar tidak berkedip.
			var seed_value: float = float(lane * 23 + column * 11)
			var patch_center := Vector2(cell_rect.position.x + cell_width * (0.24 + fposmod(seed_value * 0.037, 0.48)), cell_rect.position.y + lane_height * (0.24 + fposmod(seed_value * 0.021, 0.48)))
			_draw_ellipse(patch_center, cell_width * 0.17, lane_height * 0.07, Color(0.70, 0.95, 0.47, 0.055))
			for tuft in range(3):
				var tuft_x: float = cell_rect.position.x + cell_width * (0.12 + float(tuft) * 0.27) + fposmod(seed_value + float(tuft) * 7.0, 13.0)
				var tuft_y: float = cell_rect.position.y + lane_height * (0.78 + float(tuft % 2) * 0.06)
				var tuft_color := Color(0.72, 0.94, 0.53, 0.22)
				draw_line(Vector2(tuft_x, tuft_y), Vector2(tuft_x - 3.0, tuft_y - 7.0), tuft_color, 1.4, true)
				draw_line(Vector2(tuft_x, tuft_y), Vector2(tuft_x + 4.0, tuft_y - 6.0), tuft_color, 1.4, true)

			# Bunga kecil di sebagian petak untuk membuat kebun terasa hidup.
			if int(seed_value) % 4 == 0:
				var flower_center := Vector2(cell_rect.position.x + cell_width * 0.82, cell_rect.position.y + lane_height * 0.22)
				var flower_pulse: float = 1.0 + sin(visual_time * 1.4 + seed_value) * 0.08
				for petal in range(5):
					var flower_angle: float = TAU * float(petal) / 5.0
					var petal_center: Vector2 = flower_center + Vector2(cos(flower_angle), sin(flower_angle)) * 3.8 * flower_pulse
					_draw_ellipse(petal_center, 2.6, 2.1, Color("#d9b45d"), flower_angle)
				draw_circle(flower_center, 2.0, Color("#f0dfb5"))

		# Jalur gerak musuh berupa garis putus-putus yang halus.
		var lane_y: float = lane_rect.position.y + lane_height * 0.68
		for dash in range(7):
			var dash_x: float = grid.position.x + 14.0 + float(dash) * (grid.size.x - 45.0) / 7.0
			draw_line(Vector2(dash_x, lane_y), Vector2(dash_x + 10.0, lane_y), Color(0.88, 0.98, 0.68, 0.13), 1.0, true)

	# Kisi dibuat tipis agar tidak mengalahkan karakter.
	for column_line in range(COLUMN_COUNT + 1):
		var x: float = grid.position.x + float(column_line) * cell_width
		draw_line(Vector2(x, grid.position.y), Vector2(x, grid.position.y + grid.size.y), Color(0.74, 0.91, 0.57, 0.19), 1.0, true)
	for lane_line in range(LANE_COUNT + 1):
		var y: float = grid.position.y + float(lane_line) * lane_height
		draw_line(Vector2(grid.position.x, y), Vector2(grid.position.x + grid.size.x, y), Color("#a5a06b"), 2.0, true)

	# Sorotan tepi atas dan bawah papan.
	draw_line(grid.position, Vector2(grid.position.x + grid.size.x, grid.position.y), Color(0.88, 0.98, 0.70, 0.48), 2.0, true)
	draw_line(Vector2(grid.position.x, grid.position.y + grid.size.y), grid.position + grid.size, Color(0.08, 0.23, 0.12, 0.65), 3.0, true)

	# Penanda petak kosong/terisi saat kartu dipilih.
	for lane in range(LANE_COUNT):
		for column in range(COLUMN_COUNT):
			var cell_rect := Rect2(grid.position.x + float(column) * cell_width, grid.position.y + float(lane) * lane_height, cell_width, lane_height)
			if placement_enabled:
				draw_rect(cell_rect.grow(-4.0), Color(0.60, 0.96, 0.62, 0.035), false, 1.0, true)
				if hovered_cell == Vector2i(lane, column):
					var hover_color: Color = Color(0.98, 0.35, 0.31, 0.22) if _cell_is_occupied(lane, column) else Color(0.56, 1.0, 0.60, 0.22)
					draw_rect(cell_rect.grow(-5.0), hover_color, true)
					draw_rect(cell_rect.grow(-5.0), hover_color.lightened(0.30), false, 2.0, true)

func _draw_ink_grid_overlay() -> void:
	var grid: Rect2 = _grid_rect()
	var cell_width: float = grid.size.x / float(COLUMN_COUNT)
	var lane_height: float = grid.size.y / float(LANE_COUNT)
	for column_line in range(COLUMN_COUNT + 1):
		var x: float = grid.position.x + float(column_line) * cell_width
		draw_line(Vector2(x, grid.position.y), Vector2(x, grid.position.y + grid.size.y), Color(0.10, 0.12, 0.08, 0.18), 1.2, true)
	for lane_line in range(LANE_COUNT + 1):
		var y: float = grid.position.y + float(lane_line) * lane_height
		draw_line(Vector2(grid.position.x, y), Vector2(grid.position.x + grid.size.x, y), Color(0.10, 0.12, 0.08, 0.28), 2.0, true)
	if placement_enabled:
		for lane in range(LANE_COUNT):
			for column in range(COLUMN_COUNT):
				var cell_rect := Rect2(grid.position.x + float(column) * cell_width, grid.position.y + float(lane) * lane_height, cell_width, lane_height)
				draw_rect(cell_rect.grow(-4.0), Color(0.95, 0.87, 0.65, 0.08), false, 1.0, true)
				if hovered_cell == Vector2i(lane, column):
					var hover_color: Color = Color(0.68, 0.28, 0.20, 0.28) if _cell_is_occupied(lane, column) else Color(0.85, 0.72, 0.37, 0.30)
					draw_rect(cell_rect.grow(-5.0), hover_color, true)
					draw_rect(cell_rect.grow(-5.0), Color("#171a13"), false, 2.0, true)
	draw_rect(grid.grow(3.0), Color("#171a13"), false, 3.0, true)

func _draw_core_gate() -> void:
	var grid: Rect2 = _grid_rect()
	var gate_center := Vector2(grid.position.x - 13.0, grid.position.y + grid.size.y * 0.5)
	_draw_ellipse(gate_center, 21.0, grid.size.y * 0.39, Color(0.98, 0.74, 0.28, 0.09))
	var gate_rect := Rect2(gate_center.x - 8.0, grid.position.y + 12.0, 16.0, grid.size.y - 24.0)
	draw_rect(gate_rect.grow(3.0), Color("#63482e"), true)
	draw_rect(gate_rect, Color("#bd9151"), true)
	draw_rect(Rect2(gate_rect.position.x + 4.0, gate_rect.position.y + 5.0, 8.0, gate_rect.size.y - 10.0), Color("#f4d47c"), true)
	for lane in range(LANE_COUNT):
		var gem_center := Vector2(gate_center.x, get_lane_center(lane))
		var gem := PackedVector2Array([
			gem_center + Vector2(0.0, -10.0), gem_center + Vector2(8.0, 0.0),
			gem_center + Vector2(0.0, 10.0), gem_center + Vector2(-8.0, 0.0)
		])
		draw_colored_polygon(gem, Color("#fff0a6"))
		draw_polyline(PackedVector2Array([gem[0], gem[1], gem[2], gem[3], gem[0]]), Color("#d49e43"), 1.5, true)

func update_drag_preview(guardian_type: String, local_position: Vector2) -> void:
	drag_preview_active = true
	drag_guardian_type = guardian_type
	drag_position = local_position
	_update_hover(local_position)
	queue_redraw()

func reset_drag_preview() -> void:
	drag_preview_active = false
	drag_guardian_type = ""
	_update_hover(Vector2(-1000.0, -1000.0))
	queue_redraw()

func get_cell_at_local_position(position: Vector2) -> Vector2i:
	var grid: Rect2 = _grid_rect()
	if not grid.has_point(position):
		return Vector2i(-1, -1)
	var column: int = int(floor((position.x - grid.position.x) / (grid.size.x / float(COLUMN_COUNT))))
	var lane: int = int(floor((position.y - grid.position.y) / (grid.size.y / float(LANE_COUNT))))
	if lane < 0 or lane >= LANE_COUNT or column < 0 or column >= COLUMN_COUNT:
		return Vector2i(-1, -1)
	return Vector2i(lane, column)

func _draw_drag_preview() -> void:
	var cell: Vector2i = get_cell_at_local_position(drag_position)
	var tint: Color = Color("#86d68a")
	if cell.x >= 0 and cell.y >= 0 and _cell_is_occupied(cell.x, cell.y):
		tint = Color("#ed7777")
	var center: Vector2 = drag_position
	if cell.x >= 0 and cell.y >= 0:
		var grid: Rect2 = _grid_rect()
		var cell_size := Vector2(grid.size.x / float(COLUMN_COUNT), grid.size.y / float(LANE_COUNT))
		center = Vector2(grid.position.x + (float(cell.y) + 0.5) * cell_size.x, grid.position.y + (float(cell.x) + 0.5) * cell_size.y)
	_draw_ellipse(center + Vector2(0.0, 6.0), 27.0, 11.0, Color(0.0, 0.0, 0.0, 0.24))
	draw_circle(center, 27.0, Color(tint.r, tint.g, tint.b, 0.22))
	draw_arc(center, 27.0, 0.0, TAU, 32, Color(tint.r, tint.g, tint.b, 0.95), 3.0, true)
	if guardian_textures.has(drag_guardian_type):
		var preview_texture: Texture2D = guardian_textures[drag_guardian_type]
		draw_texture_rect(preview_texture, Rect2(center - Vector2(27.0, 31.0), Vector2(54.0, 62.0)), false, Color(1.0, 1.0, 1.0, 0.78))
	else:
		_draw_guardian_icon(drag_guardian_type, center, 0.76)

func _draw_guardian(guardian: Dictionary) -> void:
	var center: Vector2 = get_guardian_center(guardian)
	var bob_seed: float = float(int(guardian.get("lane", 0)) * 7 + int(guardian.get("column", 0)))
	center += Vector2(0.0, sin(visual_time * 2.3 + bob_seed) * 2.0)
	_draw_ellipse(center + Vector2(0.0, 35.0), 31.0, 8.0, Color(0.0, 0.0, 0.0, 0.20))
	var guardian_type: String = str(guardian.get("type", "Plusy"))
	if guardian_textures.has(guardian_type):
		var texture: Texture2D = guardian_textures[guardian_type]
		var sprite_size := Vector2(60.0, 70.0)
		if guardian_type == "Addy Cannon":
			sprite_size = Vector2(74.0, 66.0)
		draw_texture_rect(texture, Rect2(center - sprite_size * 0.5 + Vector2(0.0, -2.0), sprite_size), false)
	else:
		_draw_guardian_icon(guardian_type, center, 1.0)

	# Semua Guardian memiliki HP dan bar kesehatan yang selalu terlihat.
	var max_hp: float = maxf(float(guardian.get("max_hp", 160)), 1.0)
	var hp_ratio: float = clampf(float(guardian.get("hp", max_hp)) / max_hp, 0.0, 1.0)
	var bar_width: float = 48.0
	var bar_position := Vector2(center.x - bar_width * 0.5, center.y + 34.0)
	draw_rect(Rect2(bar_position, Vector2(bar_width, 6.0)), Color("#171a13"), true)
	draw_rect(Rect2(bar_position, Vector2(bar_width * hp_ratio, 6.0)), Color("#a6e6b8") if hp_ratio > 0.35 else Color("#b95c49"), true)
	draw_rect(Rect2(bar_position, Vector2(bar_width, 6.0)), Color("#eee2c4"), false, 1.0, true)

func _draw_guardian_icon(guardian_type: String, center: Vector2, scale_value: float) -> void:
	if guardian_type == "Plusy":
		var stem_start := center + Vector2(0.0, 5.0 * scale_value)
		var stem_end := center + Vector2(0.0, 30.0 * scale_value)
		draw_line(stem_start, stem_end, Color("#286c3a"), 7.0 * scale_value, true)
		_draw_leaf(center + Vector2(-3.0, 19.0 * scale_value), 2.85, 23.0 * scale_value, 8.0 * scale_value, Color("#48a94c"))
		_draw_leaf(center + Vector2(3.0, 23.0 * scale_value), 0.28, 22.0 * scale_value, 8.0 * scale_value, Color("#64c95a"))
		var head := center + Vector2(0.0, -7.0 * scale_value)
		for petal_index in range(8):
			var angle: float = TAU * float(petal_index) / 8.0 + visual_time * 0.13
			var petal_center: Vector2 = head + Vector2(cos(angle), sin(angle)) * 18.0 * scale_value
			_draw_ellipse(petal_center, 7.0 * scale_value, 10.0 * scale_value, Color("#ffc84f"), angle + PI * 0.5)
			draw_arc(petal_center, 8.0 * scale_value, 0.0, TAU, 16, Color("#f9e7a1"), 1.0, true)
		draw_circle(head, 15.0 * scale_value, Color("#f8df7a"))
		draw_arc(head, 15.0 * scale_value, 0.0, TAU, 28, Color("#fff3ba"), 2.0, true)
		_draw_eyes(head + Vector2(0.0, -1.0 * scale_value), 10.0 * scale_value, 4.0 * scale_value)
		draw_arc(head + Vector2(0.0, 2.0 * scale_value), 5.0 * scale_value, 0.18, PI - 0.18, 12, Color("#704a28"), 1.8 * scale_value, true)
	elif guardian_type == "Addy Cannon":
		_draw_leaf(center + Vector2(-3.0, 20.0 * scale_value), 2.8, 24.0 * scale_value, 9.0 * scale_value, Color("#419d4a"))
		_draw_leaf(center + Vector2(3.0, 22.0 * scale_value), 0.30, 23.0 * scale_value, 8.0 * scale_value, Color("#5fbe55"))
		var head := center + Vector2(-1.0 * scale_value, -7.0 * scale_value)
		# Laras meriam digambar lebih dahulu supaya menyatu dengan kepala.
		draw_line(head + Vector2(9.0 * scale_value, 0.0), head + Vector2(37.0 * scale_value, 0.0), Color("#235c76"), 17.0 * scale_value, true)
		draw_line(head + Vector2(10.0 * scale_value, -1.0 * scale_value), head + Vector2(36.0 * scale_value, -1.0 * scale_value), Color("#72c9ed"), 10.0 * scale_value, true)
		draw_circle(head + Vector2(37.0 * scale_value, 0.0), 8.0 * scale_value, Color("#c7f3ff"))
		draw_circle(head + Vector2(37.0 * scale_value, 0.0), 4.5 * scale_value, Color("#2d7da3"))
		draw_circle(head, 21.0 * scale_value, Color("#59b8e8"))
		draw_arc(head, 21.0 * scale_value, 0.0, TAU, 28, Color("#bdeeff"), 2.0, true)
		_draw_eyes(head + Vector2(-3.0 * scale_value, -4.0 * scale_value), 10.0 * scale_value, 4.0 * scale_value)
		draw_arc(head + Vector2(-1.0 * scale_value, 3.0 * scale_value), 5.0 * scale_value, 0.15, PI - 0.15, 12, Color("#1f5874"), 1.7 * scale_value, true)
		draw_circle(head + Vector2(-9.0 * scale_value, -13.0 * scale_value), 4.0 * scale_value, Color("#bdeeff"))
	else:
		var top_face := PackedVector2Array([
			center + Vector2(0.0, -27.0 * scale_value), center + Vector2(23.0 * scale_value, -15.0 * scale_value),
			center + Vector2(0.0, -3.0 * scale_value), center + Vector2(-23.0 * scale_value, -15.0 * scale_value)
		])
		var right_face := PackedVector2Array([
			center + Vector2(0.0, -3.0 * scale_value), center + Vector2(23.0 * scale_value, -15.0 * scale_value),
			center + Vector2(23.0 * scale_value, 15.0 * scale_value), center + Vector2(0.0, 28.0 * scale_value)
		])
		var front_face := PackedVector2Array([
			center + Vector2(-23.0 * scale_value, -15.0 * scale_value), center + Vector2(0.0, -3.0 * scale_value),
			center + Vector2(0.0, 28.0 * scale_value), center + Vector2(-23.0 * scale_value, 15.0 * scale_value)
		])
		draw_colored_polygon(right_face, Color("#a8793d"))
		draw_colored_polygon(top_face, Color("#f5d58a"))
		draw_colored_polygon(front_face, Color("#e7b968"))
		draw_polyline(PackedVector2Array([top_face[0], top_face[1], right_face[2], right_face[3], front_face[3], front_face[0], top_face[0]]), Color("#fff0c5"), 2.0 * scale_value, true)
		_draw_eyes(center + Vector2(-11.0 * scale_value, -1.0 * scale_value), 7.0 * scale_value, 3.3 * scale_value)
		draw_line(center + Vector2(-15.0 * scale_value, 8.0 * scale_value), center + Vector2(-6.0 * scale_value, 8.0 * scale_value), Color("#76502b"), 2.0 * scale_value, true)
		draw_line(center + Vector2(7.0 * scale_value, 7.0 * scale_value), center + Vector2(16.0 * scale_value, 2.0 * scale_value), Color("#fff0c5"), 3.0 * scale_value, true)

func _draw_enemy(enemy: Dictionary) -> void:
	var enemy_lane: int = int(enemy.get("lane", 0))
	var enemy_id: float = float(enemy.get("id", 0))
	var walk: float = sin(visual_time * 8.0 + enemy_id) * 4.0
	var center := Vector2(float(enemy.get("x", size.x - 35.0)), get_lane_center(enemy_lane) + sin(visual_time * 4.0 + enemy_id) * 2.4)
	var enemy_type: String = str(enemy.get("type", "Error Blob"))
	var enemy_color: Color = Color("#ed7b83")
	if enemy_type == "Minus Monster":
		enemy_color = Color("#a778df")
	elif enemy_type == "Calculator Bug":
		enemy_color = Color("#eea04d")

	_draw_ellipse(center + Vector2(0.0, 28.0), 24.0, 7.0, Color(0.0, 0.0, 0.0, 0.20))
	if enemy_textures.has(enemy_type):
		var enemy_texture: Texture2D = enemy_textures[enemy_type]
		var sprite_size := Vector2(58.0, 64.0)
		if enemy_type == "Calculator Bug":
			sprite_size = Vector2(60.0, 60.0)
		draw_texture_rect(enemy_texture, Rect2(center - sprite_size * 0.5 + Vector2(0.0, -2.0), sprite_size), false)
		_draw_enemy_health_bar(center, enemy)
		return
	# Fallback procedural enemy, dipakai sampai PNG orisinal tersedia.
	draw_line(center + Vector2(-12.0, 10.0), center + Vector2(-21.0, 20.0 + walk), enemy_color.darkened(0.22), 5.0, true)
	draw_line(center + Vector2(12.0, 10.0), center + Vector2(21.0, 20.0 - walk), enemy_color.darkened(0.22), 5.0, true)
	draw_line(center + Vector2(-7.0, 18.0), center + Vector2(-12.0, 28.0 + walk), enemy_color.darkened(0.28), 5.0, true)
	draw_line(center + Vector2(7.0, 18.0), center + Vector2(12.0, 28.0 - walk), enemy_color.darkened(0.28), 5.0, true)

	if enemy_type == "Minus Monster":
		var spikes: PackedVector2Array = _spike_points(center, 25.0, 9)
		draw_colored_polygon(spikes, enemy_color)
		var outline: PackedVector2Array = spikes.duplicate()
		outline.append(spikes[0])
		draw_polyline(outline, Color("#e8d8ff"), 2.0, true)
		draw_line(center + Vector2(-10.0, -15.0), center + Vector2(-13.0, -23.0), Color("#7144aa"), 4.0, true)
		draw_line(center + Vector2(10.0, -15.0), center + Vector2(13.0, -23.0), Color("#7144aa"), 4.0, true)
		draw_line(center + Vector2(-8.0, 7.0), center + Vector2(8.0, 7.0), Color("#563174"), 4.0, true)
	elif enemy_type == "Calculator Bug":
		draw_line(center + Vector2(-8.0, -14.0), center + Vector2(-13.0, -25.0), Color("#9b5b2a"), 2.5, true)
		draw_line(center + Vector2(8.0, -14.0), center + Vector2(13.0, -25.0), Color("#9b5b2a"), 2.5, true)
		draw_circle(center + Vector2(-13.0, -25.0), 3.5, Color("#ffe6a4"))
		draw_circle(center + Vector2(13.0, -25.0), 3.5, Color("#ffe6a4"))
		draw_rect(Rect2(center.x - 19.0, center.y - 19.0, 38.0, 39.0), Color("#9b5b2a"), true)
		draw_rect(Rect2(center.x - 16.0, center.y - 16.0, 32.0, 33.0), enemy_color, true)
		draw_rect(Rect2(center.x - 11.0, center.y - 12.0, 22.0, 9.0), Color("#633f2c"), true)
		draw_string(ThemeDB.fallback_font, Vector2(center.x - 10.0, center.y - 5.0), "−", HORIZONTAL_ALIGNMENT_CENTER, 20.0, 10, Color("#fff0c8"))
		for key_index in range(3):
			draw_rect(Rect2(center.x - 10.0 + float(key_index) * 8.0, center.y + 1.0, 5.0, 5.0), Color("#fff0c8"), true)
	else:
		_draw_ellipse(center, 21.0, 23.0, enemy_color)
		_draw_ellipse(center + Vector2(-8.0, -10.0), 7.0, 4.0, Color(1.0, 0.87, 0.86, 0.46), -0.35)
		draw_circle(center + Vector2(-7.0, 0.0), 5.0, Color("#fff5e7"))
		draw_circle(center + Vector2(7.0, 0.0), 5.0, Color("#fff5e7"))
		draw_circle(center + Vector2(-6.0, 0.0), 2.3, Color("#44273b"))
		draw_circle(center + Vector2(8.0, 0.0), 2.3, Color("#44273b"))
		draw_line(center + Vector2(-7.0, 10.0), center + Vector2(7.0, 10.0), Color("#612c3d"), 2.5, true)
		for tooth in range(3):
			draw_line(center + Vector2(-4.0 + float(tooth) * 4.0, 10.0), center + Vector2(-4.0 + float(tooth) * 4.0, 13.0), Color("#fff1dc"), 1.3, true)

	if enemy_type != "Error Blob":
		draw_circle(center + Vector2(-6.0, -4.0), 4.2, Color("#fff5e7"))
		draw_circle(center + Vector2(7.0, -4.0), 4.2, Color("#fff5e7"))
		draw_circle(center + Vector2(-5.0, -4.0), 2.0, Color("#38243d"))
		draw_circle(center + Vector2(8.0, -4.0), 2.0, Color("#38243d"))

	_draw_enemy_health_bar(center, enemy)

func _draw_enemy_health_bar(center: Vector2, enemy: Dictionary) -> void:
	var hp: float = float(enemy.get("hp", 50))
	var max_hp: float = maxf(float(enemy.get("max_hp", 50)), 1.0)
	var hp_ratio: float = clampf(hp / max_hp, 0.0, 1.0)
	draw_rect(Rect2(center.x - 23.0, center.y - 34.0, 46.0, 5.0), Color("#171a13"), true)
	draw_rect(Rect2(center.x - 23.0, center.y - 34.0, 46.0 * hp_ratio, 5.0), Color("#8d9b59") if hp_ratio > 0.35 else Color("#b95c49"), true)
	draw_rect(Rect2(center.x - 23.0, center.y - 34.0, 46.0, 5.0), Color("#f0e3c7"), false, 1.0, true)

func _draw_projectile(projectile: Dictionary) -> void:
	var center := Vector2(float(projectile.get("x", 0.0)), float(projectile.get("y", 0.0)))
	var pulse: float = 1.0 + sin(visual_time * 18.0 + center.x * 0.04) * 0.12
	draw_line(center + Vector2(-20.0, 1.5), center + Vector2(-3.0, 0.0), Color(0.35, 0.80, 1.0, 0.28), 6.0, true)
	draw_circle(center, 10.0 * pulse, Color(0.30, 0.75, 1.0, 0.14))
	draw_circle(center, 6.0 * pulse, Color("#65d7ff"))
	draw_circle(center + Vector2(-1.5, -1.8), 2.7, Color("#f4ffff"))
	draw_arc(center, 8.0 * pulse, 0.0, TAU, 20, Color("#d4f8ff"), 1.2, true)

func _draw_visual_effect(effect: Dictionary) -> void:
	var position: Vector2 = effect.get("position", Vector2.ZERO)
	var kind: String = str(effect.get("kind", "hit"))
	var color: Color = effect.get("color", Color.WHITE)
	var life: float = float(effect.get("life", 0.0))
	var max_life: float = maxf(float(effect.get("max_life", 0.5)), 0.01)
	var progress: float = 1.0 - clampf(life / max_life, 0.0, 1.0)
	color.a = clampf(life / max_life, 0.0, 1.0)

	if kind == "wave":
		var banner_rect := Rect2(position.x - 91.0, position.y - 28.0, 182.0, 34.0)
		draw_rect(banner_rect, Color(0.04, 0.15, 0.10, 0.82 * color.a), true)
		draw_rect(banner_rect, Color(color.r, color.g, color.b, color.a), false, 2.0, true)
		draw_string(ThemeDB.fallback_font, Vector2(banner_rect.position.x, banner_rect.position.y + 22.0), str(effect.get("text", "WAVE")), HORIZONTAL_ALIGNMENT_CENTER, banner_rect.size.x, 15, color)
	elif kind == "reward":
		var star_radius: float = 7.0 + progress * 10.0
		for star_index in range(4):
			var angle: float = TAU * float(star_index) / 4.0 + visual_time * 0.8
			var star_center: Vector2 = position + Vector2(cos(angle), sin(angle)) * (12.0 + progress * 13.0)
			draw_colored_polygon(_star_points(star_center, star_radius * 0.42, star_radius), Color(color.r, color.g, color.b, color.a * 0.82))
		draw_string(ThemeDB.fallback_font, position + Vector2(-70.0, -10.0), str(effect.get("text", "+ENERGI")), HORIZONTAL_ALIGNMENT_CENTER, 140.0, 13, color)
	else:
		var radius: float = 7.0 + progress * (25.0 if kind == "defeat" else 18.0)
		draw_arc(position, radius, 0.0, TAU, 28, color, 2.4 if kind == "defeat" else 2.0, true)
		var particle_count: int = 8 if kind == "defeat" else 6
		for particle_index in range(particle_count):
			var angle: float = TAU * float(particle_index) / float(particle_count) + (progress * 0.35)
			var direction := Vector2(cos(angle), sin(angle))
			var start_point: Vector2 = position + direction * (radius * 0.50)
			var end_point: Vector2 = position + direction * (radius + 5.0)
			draw_line(start_point, end_point, color, 2.0, true)
			if kind == "defeat":
				draw_colored_polygon(_star_points(end_point, 2.0, 4.0), color)
	
	var effect_text: String = str(effect.get("text", ""))
	if not effect_text.is_empty() and kind != "wave" and kind != "reward":
		var font_size: int = 13 if kind == "hit" else 12
		var width: float = 116.0
		draw_string(ThemeDB.fallback_font, position + Vector2(-width * 0.5, -13.0), effect_text, HORIZONTAL_ALIGNMENT_CENTER, width, font_size, color)

func _draw_leaf(center: Vector2, angle: float, length: float, half_width: float, color: Color) -> void:
	var direction := Vector2(cos(angle), sin(angle))
	var side := Vector2(-direction.y, direction.x)
	var tip: Vector2 = center + direction * length
	var middle: Vector2 = center + direction * length * 0.55
	var points := PackedVector2Array([center, middle + side * half_width, tip, middle - side * half_width])
	draw_colored_polygon(points, color)
	draw_polyline(PackedVector2Array([center, middle + side * half_width, tip, middle - side * half_width, center]), color.darkened(0.24), 1.0, true)
	draw_line(center, tip, Color(0.86, 0.98, 0.67, 0.42), 1.0, true)

func _draw_eyes(center: Vector2, spacing: float, eye_size: float) -> void:
	var left_eye := center + Vector2(-spacing * 0.5, 0.0)
	var right_eye := center + Vector2(spacing * 0.5, 0.0)
	draw_circle(left_eye, eye_size, Color("#fff7df"))
	draw_circle(right_eye, eye_size, Color("#fff7df"))
	draw_circle(left_eye + Vector2(1.0, 0.8), eye_size * 0.48, Color("#243a32"))
	draw_circle(right_eye + Vector2(1.0, 0.8), eye_size * 0.48, Color("#243a32"))
	draw_circle(left_eye + Vector2(1.8, -0.6), eye_size * 0.16, Color.WHITE)
	draw_circle(right_eye + Vector2(1.8, -0.6), eye_size * 0.16, Color.WHITE)

func _draw_ellipse(center: Vector2, radius_x: float, radius_y: float, color: Color, rotation: float = 0.0) -> void:
	draw_colored_polygon(_ellipse_points(center, radius_x, radius_y, 20, rotation), color)

func _ellipse_points(center: Vector2, radius_x: float, radius_y: float, segments: int = 20, rotation: float = 0.0) -> PackedVector2Array:
	var points := PackedVector2Array()
	for index in range(segments):
		var angle: float = TAU * float(index) / float(segments)
		var point := Vector2(cos(angle) * radius_x, sin(angle) * radius_y).rotated(rotation)
		points.append(center + point)
	return points

func _spike_points(center: Vector2, radius: float, spikes: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	for index in range(spikes * 2):
		var angle: float = TAU * float(index) / float(spikes * 2) - PI / 2.0
		var current_radius: float = radius if index % 2 == 0 else radius * 0.70
		points.append(center + Vector2(cos(angle), sin(angle)) * current_radius)
	return points

func _star_points(center: Vector2, inner_radius: float, outer_radius: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	for index in range(8):
		var angle: float = TAU * float(index) / 8.0 - PI / 2.0
		var radius: float = outer_radius if index % 2 == 0 else inner_radius
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	return points

func _grid_rect() -> Rect2:
	return Rect2(Vector2(30.0, GRID_TOP_MARGIN), Vector2(maxf(size.x - 40.0, 1.0), maxf(size.y - GRID_TOP_MARGIN - GRID_BOTTOM_MARGIN, 1.0)))

func get_guardian_center(guardian: Dictionary) -> Vector2:
	var grid: Rect2 = _grid_rect()
	var cell_width: float = grid.size.x / float(COLUMN_COUNT)
	var lane_height: float = grid.size.y / float(LANE_COUNT)
	return Vector2(grid.position.x + (int(guardian.get("column", 0)) + 0.5) * cell_width, grid.position.y + (int(guardian.get("lane", 0)) + 0.5) * lane_height)

func get_lane_center(lane: int) -> float:
	var grid: Rect2 = _grid_rect()
	return grid.position.y + (float(lane) + 0.5) * (grid.size.y / float(LANE_COUNT))

func get_attack_range() -> float:
	# Jangkauan sekitar lima petak agar Guardian penyerang dapat menghadapi kelompok musuh.
	var grid: Rect2 = _grid_rect()
	return (grid.size.x / float(COLUMN_COUNT)) * 5.0

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_update_hover(event.position)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_update_hover(event.position)
		_handle_slot_click(event.position)
		accept_event()
	elif event is InputEventScreenTouch and event.pressed:
		_update_hover(event.position)
		_handle_slot_click(event.position)
		accept_event()

func _update_hover(position: Vector2) -> void:
	var next_cell := Vector2i(-1, -1)
	if placement_enabled:
		var grid: Rect2 = _grid_rect()
		if grid.has_point(position):
			var column: int = int(floor((position.x - grid.position.x) / (grid.size.x / float(COLUMN_COUNT))))
			var lane: int = int(floor((position.y - grid.position.y) / (grid.size.y / float(LANE_COUNT))))
			if lane >= 0 and lane < LANE_COUNT and column >= 0 and column < COLUMN_COUNT:
				next_cell = Vector2i(lane, column)
	if next_cell != hovered_cell:
		hovered_cell = next_cell
		queue_redraw()

func _cell_is_occupied(lane: int, column: int) -> bool:
	for guardian in guardians:
		if int(guardian.get("lane", -1)) == lane and int(guardian.get("column", -1)) == column:
			return true
	return false

func _on_mouse_exited() -> void:
	if not drag_preview_active:
		hovered_cell = Vector2i(-1, -1)
	queue_redraw()

func _handle_slot_click(position: Vector2) -> void:
	var cell: Vector2i = get_cell_at_local_position(position)
	if cell.x >= 0 and cell.y >= 0:
		slot_clicked.emit(cell.x, cell.y)
