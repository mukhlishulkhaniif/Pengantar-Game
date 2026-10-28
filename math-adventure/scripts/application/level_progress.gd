extends Node
## Katalog level, pemilihan level, pembukaan progres, dan penyimpanan lokal.
const LEVELS_PATH: String = "res://data/levels.json"
const SAVE_PATH: String = "user://math_adventure_progress.cfg"
const TOTAL_LEVELS: int = 40
const LEVELS_PER_WORLD: int = 13
const SAVE_SCHEMA_VERSION: int = 2
var selected_level_id: int = 1
var highest_unlocked_level: int = 1
var level_catalog: Dictionary = {}
var saved_stars: Dictionary = {}

func _ready() -> void:
	_load_level_catalog()
	_load_progress()

func _load_level_catalog() -> void:
	level_catalog.clear()
	if not FileAccess.file_exists(LEVELS_PATH):
		push_error("File katalog level tidak ditemukan: " + LEVELS_PATH)
		return
	var file := FileAccess.open(LEVELS_PATH, FileAccess.READ)
	if file == null:
		push_error("Tidak dapat membuka katalog level.")
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Array:
		push_error("Format data/levels.json harus berupa array JSON.")
		return
	for entry in parsed:
		if entry is Dictionary:
			level_catalog[int(entry.get("id", 0))] = entry

func _load_progress() -> void:
	var save := ConfigFile.new()
	var err: Error = save.load(SAVE_PATH)
	if err != OK and err != ERR_FILE_NOT_FOUND:
		push_warning("Progres tidak dapat dibaca; memakai progres awal.")

	var schema_version: int = int(save.get_value("meta", "schema_version", 0))
	var stored_highest: int = int(save.get_value("progress", "highest_unlocked_level", 1))
	saved_stars.clear()
	if schema_version < SAVE_SCHEMA_VERSION:
		# Migrasi dari susunan lama: setiap dunia dahulu memiliki tutorial sendiri.
		highest_unlocked_level = _migrate_legacy_highest(stored_highest)
		for level_id in range(1, TOTAL_LEVELS + 1):
			var legacy_id: int = _legacy_star_id(level_id)
			var stars: int = int(save.get_value("stars", str(legacy_id), 0))
			if stars > 0:
				saved_stars[level_id] = clampi(stars, 1, 3)
		_save_progress()
	else:
		highest_unlocked_level = clampi(stored_highest, 1, TOTAL_LEVELS)
		for level_id in range(1, TOTAL_LEVELS + 1):
			var stars: int = int(save.get_value("stars", str(level_id), 0))
			if stars > 0:
				saved_stars[level_id] = clampi(stars, 1, 3)

func _migrate_legacy_highest(old_level_id: int) -> int:
	# Old IDs 1-14 map directly; old world 2 tutorial was ID 15 and world 3 tutorial ID 29.
	if old_level_id <= 15:
		return clampi(old_level_id, 1, TOTAL_LEVELS)
	if old_level_id <= 29:
		return clampi(old_level_id - 1, 1, TOTAL_LEVELS)
	return clampi(old_level_id - 2, 1, TOTAL_LEVELS)

func _legacy_star_id(new_level_id: int) -> int:
	if new_level_id <= 14:
		return new_level_id
	if new_level_id <= 27:
		return new_level_id + 1
	return new_level_id + 2

func _save_progress() -> void:
	var save := ConfigFile.new()
	save.set_value("meta", "schema_version", SAVE_SCHEMA_VERSION)
	save.set_value("progress", "highest_unlocked_level", highest_unlocked_level)
	for level_id in range(1, TOTAL_LEVELS + 1):
		save.set_value("stars", str(level_id), int(saved_stars.get(level_id, 0)))
	var err: Error = save.save(SAVE_PATH)
	if err != OK:
		push_warning("Progres level gagal disimpan.")

func get_level_data(level_id: int) -> Dictionary:
	if level_catalog.has(level_id):
		return level_catalog[level_id]
	return level_catalog.get(1, {})

func get_all_levels() -> Array:
	var result: Array = []
	for level_id in range(1, TOTAL_LEVELS + 1):
		result.append(get_level_data(level_id))
	return result

func get_world_levels(world_id: int) -> Array:
	var result: Array = []
	for level_id in range(1, TOTAL_LEVELS + 1):
		var entry: Dictionary = get_level_data(level_id)
		if int(entry.get("world_id", 0)) == world_id:
			result.append(entry)
	return result

func is_level_unlocked(level_id: int) -> bool:
	return level_id >= 1 and level_id <= highest_unlocked_level

func select_level(level_id: int) -> bool:
	if not is_level_unlocked(level_id) or not level_catalog.has(level_id):
		return false
	selected_level_id = level_id
	return true

func get_level_stars(level_id: int) -> int:
	return int(saved_stars.get(level_id, 0))

func get_total_stars() -> int:
	var total: int = 0
	for value in saved_stars.values():
		total += int(value)
	return total

func get_world_completed_count(world_id: int) -> int:
	var completed: int = 0
	for entry in get_world_levels(world_id):
		if int(saved_stars.get(int(entry.get("id", 0)), 0)) > 0:
			completed += 1
	return completed

func complete_level(level_id: int, stars: int) -> void:
	if not level_catalog.has(level_id):
		return
	var clamped_stars: int = clampi(stars, 1, 3)
	saved_stars[level_id] = maxi(int(saved_stars.get(level_id, 0)), clamped_stars)
	if level_id < TOTAL_LEVELS:
		highest_unlocked_level = maxi(highest_unlocked_level, level_id + 1)
	_save_progress()

func get_tier_names() -> Array[String]:
	return ["Tutorial", "Introduction", "Challenge", "Advanced", "Boss"]
