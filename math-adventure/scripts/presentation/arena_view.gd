extends Control

signal slot_clicked(lane: int, column: int)

const LANE_COUNT: int = 3
const COLUMN_COUNT: int = 6

var guardians: Array = []
var enemies: Array = []

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = Vector2(650, 450)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("#16392f"), true)
	var grid: Rect2 = _grid_rect()
	var cell_width: float = grid.size.x / float(COLUMN_COUNT)
	var lane_height: float = grid.size.y / float(LANE_COUNT)

	for lane in range(LANE_COUNT):
		var lane_rect := Rect2(grid.position.x, grid.position.y + lane * lane_height, grid.size.x, lane_height)
		draw_rect(lane_rect, Color("#214b3a") if lane % 2 == 0 else Color("#1d4536"), true)
		draw_rect(Rect2(lane_rect.position.x, lane_rect.position.y + lane_height - 5.0, lane_rect.size.x, 5.0), Color("#326348"), true)
		for column in range(COLUMN_COUNT):
			var cell_rect := Rect2(grid.position.x + column * cell_width, lane_rect.position.y, cell_width, lane_height - 5.0)
			if (lane + column) % 2 == 0:
				draw_rect(cell_rect, Color(0.75, 0.95, 0.75, 0.035), true)

	for column_line in range(COLUMN_COUNT + 1):
		var x: float = grid.position.x + column_line * cell_width
		draw_line(Vector2(x, grid.position.y), Vector2(x, grid.position.y + grid.size.y), Color("#46715a"), 1.0)
	for lane_line in range(LANE_COUNT + 1):
		var y: float = grid.position.y + lane_line * lane_height
		draw_line(Vector2(grid.position.x, y), Vector2(grid.position.x + grid.size.x, y), Color("#46715a"), 2.0)

	# Core Numeria: the protected objective at the left edge.
	draw_rect(Rect2(grid.position.x - 3.0, grid.position.y + 10.0, 8.0, grid.size.y - 20.0), Color("#f5d57d"), true)
	draw_string(ThemeDB.fallback_font, Vector2(grid.position.x + 3.0, grid.position.y - 5.0), "CORE", HORIZONTAL_ALIGNMENT_LEFT, 50.0, 12, Color("#f5d57d"))

	for guardian in guardians:
		var center: Vector2 = get_guardian_center(guardian)
		var guardian_type: String = str(guardian.get("type", "Plusy"))
		var body_color: Color = Color("#65d5a2")
		var symbol: String = "+"
		if guardian_type == "Addy Cannon":
			body_color = Color("#64b8f2")
			symbol = "A"
		elif guardian_type == "Shield Cube":
			body_color = Color("#e5b86b")
			symbol = "S"
		draw_circle(center + Vector2(0, 4), 25.0, Color(0, 0, 0, 0.2))
		draw_circle(center, 23.0, body_color)
		draw_arc(center, 23.0, 0.0, TAU, 32, Color("#e8f6df"), 2.0)
		draw_circle(center + Vector2(-7, -5), 2.5, Color("#16392f"))
		draw_circle(center + Vector2(7, -5), 2.5, Color("#16392f"))
		draw_string(ThemeDB.fallback_font, Vector2(center.x - 17.0, center.y + 13.0), symbol, HORIZONTAL_ALIGNMENT_CENTER, 34.0, 20, Color("#16392f"))
		if guardian_type == "Shield Cube":
			var hp_ratio: float = clampf(float(guardian.get("hp", 300)) / 300.0, 0.0, 1.0)
			draw_rect(Rect2(center.x - 23.0, center.y + 29.0, 46.0, 4.0), Color("#123027"), true)
			draw_rect(Rect2(center.x - 23.0, center.y + 29.0, 46.0 * hp_ratio, 4.0), Color("#a9e6a1"), true)

	for enemy in enemies:
		var enemy_lane: int = int(enemy.get("lane", 0))
		var center := Vector2(float(enemy.get("x", size.x - 35.0)), grid.position.y + (enemy_lane + 0.5) * lane_height)
		var enemy_type: String = str(enemy.get("type", "Error Blob"))
		var enemy_color: Color = Color("#e77f83") if enemy_type == "Error Blob" else Color("#bd8be8")
		draw_circle(center + Vector2(0, 4), 21.0, Color(0, 0, 0, 0.2))
		draw_circle(center, 19.0, enemy_color)
		draw_circle(center + Vector2(-6, -4), 3.0, Color("#3d243c"))
		draw_circle(center + Vector2(6, -4), 3.0, Color("#3d243c"))
		draw_line(center + Vector2(-5, 6), center + Vector2(5, 6), Color("#3d243c"), 2.0)
		var hp: float = float(enemy.get("hp", 50))
		var max_hp: float = maxf(float(enemy.get("max_hp", 50)), 1.0)
		draw_rect(Rect2(center.x - 20.0, center.y - 28.0, 40.0, 5.0), Color("#432d37"), true)
		draw_rect(Rect2(center.x - 20.0, center.y - 28.0, 40.0 * clampf(hp / max_hp, 0.0, 1.0), 5.0), Color("#a8e6a1"), true)

func _grid_rect() -> Rect2:
	return Rect2(Vector2(22.0, 24.0), Vector2(maxf(size.x - 44.0, 1.0), maxf(size.y - 48.0, 1.0)))

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
