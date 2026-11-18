extends Node2D

const PLAYER_SPEED := 220.0
const PLAYER_SIZE := 32.0
const START_CELL := Vector2i(11, 8)
const TARGET_CELL := Vector2i(29, 21)

var enemies: Array[Vector2] = []
var map_width := 0
var map_height := 0
var player_position := Vector2.ZERO
var target_position := Vector2.ZERO
var camera: Camera2D
var tactical_mode := false
var mission_complete := false

@export var entity_atlas: Texture2D
@export var fog_texture: Texture2D
@export var vision_distance: float = 210.0

@onready var map_layer: TileMapLayer = $Level
@onready var status_label: Label = $HUD/Status
@onready var instructions_label: Label = $HUD/Instructions

func _ready() -> void:
	if entity_atlas == null:
		entity_atlas = _load_svg_texture("res://assets/entities.svg")
	if entity_atlas == null:
		push_warning("Entity atlas is unavailable; entity icons cannot be drawn")
	if fog_texture == null:
		fog_texture = _load_svg_texture("res://assets/fog.svg")
	if fog_texture == null:
		push_warning("Fog texture is unavailable; fog pattern cannot be drawn")
	var used_rect := map_layer.get_used_rect()
	map_width = used_rect.end.x
	map_height = used_rect.end.y
	if map_width <= 0 or map_height <= 0:
		push_error("Level TileMapLayer has no cells")
		set_process(false)
		set_physics_process(false)
		return
	if not _is_walkable_cell(START_CELL) or not _is_walkable_cell(TARGET_CELL):
		push_error("Map start or target cell is blocked or outside the map")
		set_process(false)
		set_physics_process(false)
		return
	player_position = _map_to_world(START_CELL)
	target_position = _map_to_world(TARGET_CELL)
	camera = Camera2D.new()
	camera.position = player_position
	add_child(camera)
	camera.make_current()

func _load_svg_texture(path: String) -> Texture2D:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return null
	var image := Image.new()
	var error := image.load_svg_from_string(file.get_as_text())
	if error != OK:
		push_error("Could not parse SVG texture %s: %s" % [path, error_string(error)])
		return null
	return ImageTexture.create_from_image(image)

func _map_to_world(cell: Vector2i) -> Vector2:
	return map_layer.to_global(map_layer.map_to_local(cell))

func _map_origin() -> Vector2:
	return map_layer.position

func _tile_size() -> Vector2:
	return Vector2(map_layer.tile_set.tile_size)

func _tile_data_at(cell: Vector2i) -> TileData:
	if (
		cell.x < 0
		or cell.x >= map_width
		or cell.y < 0
		or cell.y >= map_height
	):
		return null
	return map_layer.get_cell_tile_data(cell)

func _tile_blocks_movement(cell: Vector2i) -> bool:
	var tile_data := _tile_data_at(cell)
	return tile_data != null and bool(tile_data.get_custom_data("blocks_movement"))

func _tile_blocks_vision(cell: Vector2i) -> bool:
	var tile_data := _tile_data_at(cell)
	return tile_data != null and bool(tile_data.get_custom_data("blocks_vision"))

func _is_walkable_cell(cell: Vector2i) -> bool:
	return (
		cell.x >= 0
		and cell.x < map_width
		and cell.y >= 0
		and cell.y < map_height
		and not _tile_blocks_movement(cell)
	)

func _physics_process(delta: float) -> void:
	if tactical_mode or mission_complete:
		return

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction += Vector2(
		float(Input.is_key_pressed(KEY_D)) - float(Input.is_key_pressed(KEY_A)),
		float(Input.is_key_pressed(KEY_S)) - float(Input.is_key_pressed(KEY_W))
	)
	_move_player(direction.normalized() * PLAYER_SPEED * delta)
	camera.position = player_position

	if player_position.distance_to(target_position) < PLAYER_SIZE:
		mission_complete = true
		status_label.text = "Mission complete! You reached the target."

	queue_redraw()

func _move_player(movement: Vector2) -> void:
	var half_size := Vector2.ONE * (PLAYER_SIZE / 2.0)
	var next_x := player_position + Vector2(movement.x, 0.0)
	if _inside_map(next_x) and not _overlaps_wall(next_x, half_size):
		player_position = next_x

	var next_y := player_position + Vector2(0.0, movement.y)
	if _inside_map(next_y) and not _overlaps_wall(next_y, half_size):
		player_position = next_y

func _inside_map(position_to_check: Vector2) -> bool:
	var map_size := Vector2(map_width, map_height) * _tile_size()
	var map_origin := _map_origin()
	return (
		position_to_check.x >= map_origin.x + PLAYER_SIZE / 2.0
		and position_to_check.x <= map_origin.x + map_size.x - PLAYER_SIZE / 2.0
		and position_to_check.y >= map_origin.y + PLAYER_SIZE / 2.0
		and position_to_check.y <= map_origin.y + map_size.y - PLAYER_SIZE / 2.0
	)

func _overlaps_wall(position_to_check: Vector2, half_size: Vector2) -> bool:
	var map_origin := _map_origin()
	var tile_size := _tile_size()
	for row in range(map_height):
		for column in range(map_width):
			var cell := Vector2i(column, row)
			if not _tile_blocks_movement(cell):
				continue
			var tile_rect := Rect2(
				map_origin + Vector2(column, row) * tile_size,
				tile_size
			)
			if tile_rect.grow(half_size.x).has_point(position_to_check):
				return true
	return false

func _unhandled_input(event: InputEvent) -> void:
	if mission_complete:
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_TAB:
		tactical_mode = not tactical_mode
		queue_redraw()
	elif tactical_mode and event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_take_over_visible_enemy(get_global_mouse_position())

func _take_over_visible_enemy(click_position: Vector2) -> void:
	for index in range(enemies.size()):
		if not _can_see_enemy(enemies[index]):
			continue
		if click_position.distance_to(enemies[index]) <= PLAYER_SIZE:
			var previous_host := player_position
			player_position = enemies[index]
			camera.position = player_position
			enemies.remove_at(index)
			enemies.append(previous_host)
			queue_redraw()
			return

func _is_visible(position_to_check: Vector2) -> bool:
	if player_position.distance_squared_to(position_to_check) > vision_distance * vision_distance:
		return false
	return _has_line_of_sight(position_to_check)

func _can_see_enemy(enemy_position: Vector2) -> bool:
	return _is_visible(enemy_position)

func _has_line_of_sight(target: Vector2) -> bool:
	var distance := player_position.distance_to(target)
	var steps := int(ceil(distance / 8.0))
	var target_cell := map_layer.local_to_map(map_layer.to_local(target))
	for step in range(1, steps):
		var point := player_position.lerp(target, float(step) / steps)
		var cell := map_layer.local_to_map(map_layer.to_local(point))
		if cell != target_cell and _tile_blocks_vision(cell):
			return false
	return true

func _process(_delta: float) -> void:
	if mission_complete:
		return
	if tactical_mode:
		if enemies.is_empty():
			status_label.text = "TACTICAL VIEW — no enemies are present"
			instructions_label.text = "Tab: return to mission"
		else:
			status_label.text = "TACTICAL VIEW — click a visible red enemy to take over"
			instructions_label.text = "Only enemies in sight are selectable    |    Tab: return to mission"
	elif enemies.is_empty():
		status_label.text = "No enemies remain. Reach the gold target."
		instructions_label.text = "WASD / arrows: move    |    Tab: tactical view"
	else:
		status_label.text = "Reach the gold target. Enemies can only be taken over in tactical view."
		instructions_label.text = "WASD / arrows: move    |    Tab: tactical view    |    Green: you"

func _draw() -> void:
	var map_rect := Rect2(
		_map_origin(),
		Vector2(map_width, map_height) * _tile_size()
	)
	draw_rect(map_rect, Color("#71849b"), false, 2.0)

	_draw_fog(map_rect)

	if entity_atlas != null:
		_draw_entity(target_position, 2 if _is_visible(target_position) else 3)
		for enemy in enemies:
			_draw_entity(enemy, 4 if _can_see_enemy(enemy) else 5)
		_draw_entity(player_position, 0)

	if tactical_mode:
		draw_rect(map_rect, Color("#dce8f5"), false, 3.0)

func _draw_fog(map_rect: Rect2) -> void:
	var tile_size := _tile_size()
	for row in range(map_height):
		for column in range(map_width):
			var cell := Vector2i(column, row)
			var cell_position := _map_to_world(cell) - tile_size / 2.0
			var cell_rect := Rect2(cell_position, tile_size).intersection(map_rect)
			if not _is_visible(cell_rect.get_center()):
				draw_rect(cell_rect, Color(0.02, 0.03, 0.05, 0.62))
				if fog_texture != null:
					draw_texture_rect(fog_texture, cell_rect, false, Color(1, 1, 1, 0.52))

func _draw_entity(center: Vector2, atlas_index: int) -> void:
	var icon_rect := Rect2(
		center - Vector2.ONE * (PLAYER_SIZE / 2.0),
		Vector2.ONE * PLAYER_SIZE
	)
	var texture_rect := Rect2(
		Vector2(atlas_index * PLAYER_SIZE, 0.0),
		Vector2.ONE * PLAYER_SIZE
	)
	draw_texture_rect_region(entity_atlas, icon_rect, texture_rect)
