extends Node3D

@onready var villager_scene: PackedScene = preload("res://assets/char/barbarian/Barbarian.tscn")

@onready var camera: Camera3D = $Camera3D
@onready var cursor: Control = $UI/Cursor
@onready var gridmap: GridMap = $Tiling/GridMap
@onready var tile_focus: Node3D = $Tiling/TileFocus
@onready var tile_focus_secondary: Node3D = $Tiling/TileFocusSecondary
@onready var mana_bar: ProgressBar = $UI/ManaBar

@export var INTERPOLATION_SPEED: float = 10
@export var FIRE_COST: int = 5
@export var WIND_COST: int = 3
@export var WATER_COST: int = 7

@export var path_points: Array[Vector3] = [] # fill externally
@export var player1_pos: Vector3
@export var player2_pos: Vector3

var cur_mana: int = 0
var max_mana: int = 10

var cur_cell: Vector3i = Vector3i.ZERO
var over_cell: Vector3i = Vector3i.ZERO
var wind_grabbing: bool = false

var tiles: Dictionary = {} # Vector3 -> TileData


# ------------------------------------------------
# INIT THINGS
func _ready() -> void:
	init_tile_data()
	init_villager()

func init_tile_data():
	var used_cells = gridmap.get_used_cells()
	for cell in used_cells:
		var tileData = TileData3D.new()
		tiles[cell] = tileData
	print(tiles)

func init_villager():
	var villager_node: Villager = villager_scene.instantiate()
	villager_node.setup(gridmap, tiles, path_points, player1_pos, player2_pos)
	add_child(villager_node)

# ------------------------------------------------
# PROCESS
func _process(delta: float) -> void:
	var params = PhysicsRayQueryParameters3D.new()
	var from = camera.project_ray_origin(cursor.position)

	params.from = from
	params.to = from + camera.project_ray_normal(cursor.position) * 1000
	params.collide_with_areas = false
	params.collide_with_bodies = true
	params.set_collision_mask(1)
	params.hit_back_faces = false
	
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(params)

	if result and result.collider == gridmap:
		var pos_local = gridmap.to_local(result.position)
		over_cell = gridmap.local_to_map(pos_local)
		
		if not wind_grabbing:
			cur_cell = over_cell
			tile_focus_secondary.visible = false
		else:
			tile_focus_secondary.visible = true
		
		mini_highlight_cell(over_cell, delta)
		highlight_cell(cur_cell, delta)
		tile_focus.scale = lerp(tile_focus.scale, Vector3.ONE, INTERPOLATION_SPEED * delta)
	else:
		tile_focus.scale = lerp(tile_focus.scale, Vector3.ZERO, INTERPOLATION_SPEED * delta)

func highlight_cell(cell: Vector3, delta: float):
	tile_focus.position = lerp(tile_focus.position, 2 * cell + Vector3(1, 0.1, 1), INTERPOLATION_SPEED * delta)
	
func mini_highlight_cell(cell: Vector3, delta: float):
	tile_focus_secondary.position = lerp(tile_focus_secondary.position, 2 * cell + Vector3(1, 0.1, 1), INTERPOLATION_SPEED * delta)


# ------------------------------------------------
# UTILITY
func apply_tile_visual(cell: Vector3i):
	var tileData = tiles[cell]

	match tileData.state:
		TileData3D.StateType.CLEAR:
			gridmap.set_cell_item(cell, 0)  # SimpleTile
		TileData3D.StateType.P1:
			gridmap.set_cell_item(cell, 1)  # Player1Tile
		TileData3D.StateType.P2:
			gridmap.set_cell_item(cell, 0)  # maybe another index later

func update_progress_bar() -> void:
	mana_bar.value = cur_mana

func spend_mana(cost: int) -> bool:
	if cost <= cur_mana:
		cur_mana -= cost
		update_progress_bar()
		return true # successful
	else:
		return false


# ------------------------------------------------
# SIGNALS
func _on_cursor_grabbing(action_type: PlayerCursor.ActionType) -> void:
	if action_type == PlayerCursor.ActionType.WIND:
		wind_grabbing = true
	
	elif action_type == PlayerCursor.ActionType.FIRE:
		if tiles.has(cur_cell):
			if spend_mana(FIRE_COST):
				var tileData = tiles[cur_cell]
				tileData.state = TileData3D.StateType.P1
				apply_tile_visual(cur_cell)
	
	elif action_type == PlayerCursor.ActionType.WATER:
		if tiles.has(cur_cell):
			if spend_mana(WATER_COST):
				var tileData = tiles[cur_cell]
				tileData.state = TileData3D.StateType.CLEAR
				apply_tile_visual(cur_cell)
	else:
		pass

func _on_cursor_dropping() -> void:
	if wind_grabbing:
		if over_cell == cur_cell:
			return
		if tiles.has(over_cell) and tiles.has(cur_cell):
			if spend_mana(WIND_COST):
				var curTileData = tiles[cur_cell]
				var overTileData = tiles[over_cell]
				overTileData.state = curTileData.state
				curTileData.state = TileData3D.StateType.CLEAR
				apply_tile_visual(cur_cell)
				apply_tile_visual(over_cell)
	wind_grabbing = false

func _on_get_mana_timeout() -> void:
	if cur_mana < max_mana:
		cur_mana += 1
	update_progress_bar()
