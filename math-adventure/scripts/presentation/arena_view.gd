extends Control

signal slot_clicked(lane: int, column: int)

const LANE_COUNT: int = 3
const COLUMN_COUNT: int = 6

var guardians: Array = []
var enemies: Array = []
var projectiles: Array = []
var placement_enabled: bool = false
var visual_time: float = 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = Vector2(620, 420)

func _process(delta: float) -> void:
	visual_time += delta
	if not guardians.is_empty() or not enemies.is_empty() or not projectiles.is_empty():
		queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("#112e29"), true)
	var grid: Rect2 = _grid_rect()
	var cell_width: float = grid.size.x / float(COLUMN_COUNT)
	var lane_height: float = grid.size.y / float(LANE_COUNT)

	# Rumput berlapis dan petak penempatan.
	for lane in range(LANE_COUNT):
		var lane_rect := Rect2(grid.position.x, grid.position.y + lane * lane_height, grid.size.x, lane_height)
		draw_rect(lane_rect, Color("#214b3a") if lane % 2 == 0 else Color("#1c4234"), true)
		for column in range(COLUMN_COUNT):
			var cell_rect := Rect2(grid.position.x + column * cell_width, lane_rect.position.y, cell_width, lane_height)
			var shade: Color = Color("#d7f5c8", 0.035) if (lane + column) % 2 == 0 else Color(0.0, 0.0, 0.0, 0.025)
			draw_rect(cell_rect, shade, true)
			if placement_enabled:
				draw_rect(cell_rect.grow(-3.0), Color(0.65, 0.95, 0.72, 0.045), false, 1.0)
			# Rumput kecil sebagai detail visual.
			var grass_x: float = cell_rect.position.x + cell_width * 0.72
			var grass_y: float = cell_rect.position.y + lane_height * 0.72
			draw_line(Vector2(grass_x, grass_y), Vector2(grass_x - 3.0, grass_y - 7.0), Color(0.60, 0.82, 0.49, 0.25), 1.3)
			draw_line(Vector2(grass_x, grass_y), Vector2(grass_x + 4.0, grass_y - 5.0), Color(0.60, 0.82, 0.49, 0.22), 1.3)
		draw_rect(Rect2(lane_rect.position.x, lane_rect.position.y + lane_height - 4.0, lane_rect.size.x, 4.0), Color("#326348"), true)

	for column_line in range(COLUMN_COUNT + 1):
		var x: float = grid.position.x + column_line * cell_width
		draw_line(Vector2(x, grid.position.y), Vector2(x, grid.position.y + grid.size.y), Color("#527c60"), 1.2)
	for lane_line in range(LANE_COUNT + 1):
		var y: float = grid.position.y + lane_line * lane_height
		draw_line(Vector2(grid.position.x, y), Vector2(grid.position.x + grid.size.x, y), Color("#527c60"), 2.0)

	for lane in range(LANE_COUNT):
		draw_string(ThemeDB.fallback_font, Vector2(5.0, grid.position.y + (lane + 0.5) * lane_height + 4.0), "J%d" % (lane + 1), HORIZONTAL_ALIGNMENT_LEFT, 30.0, 12, Color("#9fbdb2"))

	# Core Numeria di sisi kiri.
	var core_rect := Rect2(grid.position.x - 25.0, grid.position.y + 12.0, 17.0, grid.size.y - 24.0)
	draw_rect(core_rect, Color("#b98548"), true)
	draw_rect(Rect2(core_rect.position.x + 4.0, core_rect.position.y + 12.0, 9.0, core_rect.size.y - 24.0), Color("#f5d57d"), true)
	draw_string(ThemeDB.fallback_font, Vector2(core_rect.position.x - 3.0, grid.position.y + grid.size.y + 17.0), "CORE", HORIZONTAL_ALIGNMENT_LEFT, 45.0, 11, Color("#f5d57d"))

	for guardian in guardians:
		_draw_guardian(guardian)
	for enemy in enemies:
		_draw_enemy(enemy)
	for projectile in projectiles:
		_draw_projectile(projectile)

	if placement_enabled:
		draw_string(ThemeDB.fallback_font, Vector2(grid.position.x + 8.0, 17.0), "PILIH PETAK KOSONG UNTUK MENEMPATKAN GUARDIAN", HORIZONTAL_ALIGNMENT_LEFT, grid.size.x - 16.0, 12, Color("#c6f2d2"))
	else:
		draw_string(ThemeDB.fallback_font, Vector2(grid.position.x + 8.0, 17.0), "PERTAHANKAN CORE NUMERIA", HORIZONTAL_ALIGNMENT_LEFT, grid.size.x - 16.0, 12, Color("#9fbdb2"))

func _draw_guardian(guardian: Dictionary) -> void:
	var center: Vector2 = get_guardian_center(guardian)
	var guardian_type: String = str(guardian.get("type", "Plusy"))
	draw_circle(center + Vector2(0.0, 5.0), 25.0, Color(0.0, 0.0, 0.0, 0.20))

	if guardian_type == "Plusy":
		for petal_index in range(6):
			var angle: float = TAU * float(petal_index) / 6.0 + visual_time * 0.12
			var petal_center: Vector2 = center + Vector2(cos(angle), sin(angle)) * 17.0
			draw_circle(petal_center, 8.0, Color("#8ee7a7"))
		draw_circle(center, 15.0, Color("#4bbf80"))
		draw_line(center + Vector2(-7.0, 1.0), center + Vector2(7.0, 1.0), Color("#103b31"), 4.0)
		draw_line(center + Vector2(0.0, -6.0), center + Vector2(0.0, 8.0), Color("#103b31"), 4.0)
	elif guardian_type == "Addy Cannon":
		draw_circle(center, 22.0, Color("#64b8f2"))
		draw_rect(Rect2(center.x + 3.0, center.y - 7.0, 25.0, 14.0), Color("#2d6d93"), true)
		draw_circle(center + Vector2(9.0, 0.0), 4.0, Color("#d7f3ff"))
		draw_circle(center + Vector2(-6.0, -5.0), 2.5, Color("#16392f"))
		draw_circle(center + Vector2(1.0, -5.0), 2.5, Color("#16392f"))
	else:
		var points := PackedVector2Array([
			center + Vector2(0.0, -25.0), center + Vector2(20.0, -14.0),
			center + Vector2(20.0, 12.0), center + Vector2(0.0, 25.0),
			center + Vector2(-20.0, 12.0), center + Vector2(-20.0, -14.0)
		])
		draw_colored_polygon(points, Color("#e5b86b"))
		draw_polyline(PackedVector2Array([points[0], points[1], points[2], points[3], points[4], points[5], points[0]]), Color("#fff0c7"), 2.0, true)
		draw_line(center + Vector2(-8.0, 0.0), center + Vector2(8.0, 0.0), Color("#68431d"), 4.0)
		draw_line(center + Vector2(0.0, -8.0), center + Vector2(0.0, 8.0), Color("#68431d"), 4.0)

	if guardian_type != "Shield Cube":
		draw_arc(center, 23.0, 0.0, TAU, 32, Color("#e8f6df"), 2.0)
	var label_text: String = "PLUSY" if guardian_type == "Plusy" else "ADDY" if guardian_type == "Addy Cannon" else "SHIELD"
	draw_string(ThemeDB.fallback_font, Vector2(center.x - 29.0, center.y + 42.0), label_text, HORIZONTAL_ALIGNMENT_CENTER, 58.0, 10, Color("#e5f1e9"))

	if guardian_type == "Shield Cube":
		var hp_ratio: float = clampf(float(guardian.get("hp", 300)) / 300.0, 0.0, 1.0)
		draw_rect(Rect2(center.x - 22.0, center.y + 29.0, 44.0, 4.0), Color("#123027"), true)
		draw_rect(Rect2(center.x - 22.0, center.y + 29.0, 44.0 * hp_ratio, 4.0), Color("#a9e6a1"), true)

func _draw_enemy(enemy: Dictionary) -> void:
	var enemy_lane: int = int(enemy.get("lane", 0))
	var center := Vector2(float(enemy.get("x", size.x - 35.0)), get_lane_center(enemy_lane))
	var enemy_type: String = str(enemy.get("type", "Error Blob"))
	var enemy_color: Color = Color("#e77f83")
	if enemy_type == "Minus Monster":
		enemy_color = Color("#bd8be8")
	elif enemy_type == "Calculator Bug":
		enemy_color = Color("#f0a35b")
	draw_circle(center + Vector2(0.0, 4.0), 21.0, Color(0.0, 0.0, 0.0, 0.20))

	if enemy_type == "Minus Monster":
		var spikes := _spike_points(center, 21.0, 8)
		draw_colored_polygon(spikes, enemy_color)
		var outline: PackedVector2Array = spikes.duplicate()
		outline.append(spikes[0])
		draw_polyline(outline, Color("#f4e6ff"), 1.8, true)
		draw_line(center + Vector2(-8.0, 2.0), center + Vector2(8.0, 2.0), Color("#46265c"), 4.0)
	elif enemy_type == "Calculator Bug":
		draw_rect(Rect2(center.x - 16.0, center.y - 17.0, 32.0, 34.0), enemy_color, true)
		draw_rect(Rect2(center.x - 10.0, center.y - 11.0, 20.0, 7.0), Color("#6a3d22"), true)
		for button_index in range(3):
			draw_circle(center + Vector2(-7.0 + float(button_index) * 7.0, 4.0), 2.0, Color("#fff0d7"))
		draw_line(center + Vector2(-7.0, -17.0), center + Vector2(-12.0, -24.0), enemy_color, 2.0)
		draw_line(center + Vector2(7.0, -17.0), center + Vector2(12.0, -24.0), enemy_color, 2.0)
	else:
		draw_circle(center, 19.0, enemy_color)
		draw_arc(center, 19.0, 0.0, TAU, 28, Color("#ffe4dc"), 1.8)
		draw_line(center + Vector2(-7.0, 7.0), center + Vector2(7.0, 7.0), Color("#3d243c"), 2.0)

	draw_circle(center + Vector2(-6.0, -4.0), 3.0, Color("#3d243c"))
	draw_circle(center + Vector2(6.0, -4.0), 3.0, Color("#3d243c"))
	var hp: float = float(enemy.get("hp", 50))
	var max_hp: float = maxf(float(enemy.get("max_hp", 50)), 1.0)
	draw_rect(Rect2(center.x - 20.0, center.y - 29.0, 40.0, 5.0), Color("#432d37"), true)
	draw_rect(Rect2(center.x - 20.0, center.y - 29.0, 40.0 * clampf(hp / max_hp, 0.0, 1.0), 5.0), Color("#a8e6a1"), true)

func _draw_projectile(projectile: Dictionary) -> void:
	var center := Vector2(float(projectile.get("x", 0.0)), float(projectile.get("y", 0.0)))
	draw_line(center + Vector2(-10.0, 0.0), center, Color(0.45, 0.85, 1.0, 0.45), 4.0)
	draw_circle(center, 5.0, Color("#a8e9ff"))
	draw_circle(center, 2.2, Color("#ffffff"))

func _spike_points(center: Vector2, radius: float, spikes: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	for index in range(spikes * 2):
		var angle: float = TAU * float(index) / float(spikes * 2) - PI / 2.0
		var current_radius: float = radius if index % 2 == 0 else radius * 0.68
		points.append(center + Vector2(cos(angle), sin(angle)) * current_radius)
	return points

func _grid_rect() -> Rect2:
	return Rect2(Vector2(40.0, 28.0), Vector2(maxf(size.x - 58.0, 1.0), maxf(size.y - 56.0, 1.0)))

func get_guardian_center(guardian: Dictionary) -> Vector2:
	var grid: Rect2 = _grid_rect()
	var cell_width: float = grid.size.x / float(COLUMN_COUNT)
	var lane_height: float = grid.size.y / float(LANE_COUNT)
	return Vector2(grid.position.x + (int(guardian.get("column", 0)) + 0.5) * cell_width, grid.position.y + (int(guardian.get("lane", 0)) + 0.5) * lane_height)

func get_lane_center(lane: int) -> float:
	var grid: Rect2 = _grid_rect()
	return grid.position.y + (lane + 0.5) * (grid.size.y / float(LANE_COUNT))

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_handle_slot_click(event.position)
		accept_event()
	elif event is InputEventScreenTouch and event.pressed:
		_handle_slot_click(event.position)
		accept_event()

func _handle_slot_click(position: Vector2) -> void:
	var grid: Rect2 = _grid_rect()
	if not grid.has_point(position):
		return
	var column: int = int(floor((position.x - grid.position.x) / (grid.size.x / float(COLUMN_COUNT))))
	var lane: int = int(floor((position.y - grid.position.y) / (grid.size.y / float(LANE_COUNT))))
	if lane >= 0 and lane < LANE_COUNT and column >= 0 and column < COLUMN_COUNT:
		slot_clicked.emit(lane, column)
