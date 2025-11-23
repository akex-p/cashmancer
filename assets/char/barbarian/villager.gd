extends CharacterBody3D
class_name Villager

enum State {
	FOLLOW_PATH,
	RUN_TO_PLAYER,
	RETURN_TO_PATH,
	IDLE
}

@export var SPEED: float = 0.8
@export var RUN_SPEED: float = 2.0
@export var ROTATION_SPEED: float = 10.0
@export var LIKE_SPEED: float = 1
@export var player1_pos: Vector3
@export var player2_pos: Vector3

var path_points: Array[Vector3] # fill externally

var cur_state: State = State.FOLLOW_PATH
var current_path_index: int = 0
var resume_path_index: int
var run_target: Vector3
var likes: float = 0.0

var direction: Vector3 = Vector3.ZERO

var gridmap: GridMap
var tiles: Dictionary

func setup(_gridmap: GridMap, _tiles: Dictionary, _path_points: Array[Vector3], _player1_pos: Vector3, _player2_pos: Vector3):
	gridmap = _gridmap
	tiles = _tiles
	path_points = _path_points
	player1_pos = _player1_pos
	player2_pos = _player2_pos

func _physics_process(delta):
	match cur_state:
		State.FOLLOW_PATH:
			follow_path(delta)
		State.RUN_TO_PLAYER:
			run_to_player(delta)
		State.RETURN_TO_PATH:
			return_to_path(delta)
			
	rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), delta * ROTATION_SPEED)


# ------------------------------------------------
# STATES
func follow_path(delta):
	if current_path_index >= path_points.size():
		return

	var target = path_points[current_path_index]
	direction = (target - global_transform.origin).normalized()
	velocity = direction * SPEED * delta
	move_and_slide()

	if global_transform.origin.distance_to(target) < 0.2:
		current_path_index = (current_path_index + 1) % path_points.size()

	# check tile
	var cell = get_tile_under_character()
	if tiles.has(cell):
		var tile = tiles[cell]
		if tile.state == TileData3D.StateType.P1:
			likes -= LIKE_SPEED * delta
			if likes <= -1:
				cur_state = State.RUN_TO_PLAYER
				run_target = player1_pos
				likes = 0.0
		elif tile.state == TileData3D.StateType.P2:
			likes += LIKE_SPEED * delta
			if likes >= 1:
				cur_state = State.RUN_TO_PLAYER
				run_target = player2_pos

func run_to_player(delta):
	direction = (run_target - global_transform.origin).normalized()
	velocity = direction * RUN_SPEED * delta
	move_and_slide()

	if global_transform.origin.distance_to(run_target) < 0.5:
		# find nearest path point to return to
		# resume_path_index = find_nearest_path_point()
		
		# choose random point
		resume_path_index = random_path_point()
		cur_state = State.RETURN_TO_PATH

func return_to_path(delta):
	var target = path_points[resume_path_index]
	direction = (target - global_transform.origin).normalized()
	velocity = direction * RUN_SPEED * delta
	move_and_slide()

	if global_transform.origin.distance_to(target) < 0.2:
		cur_state = State.FOLLOW_PATH


# ------------------------------------------------
# UTILITY
func find_nearest_path_point() -> int:
	var pos = global_transform.origin
	var closest = 0
	var best_dist = INF

	for i in path_points.size():
		var d = pos.distance_to(path_points[i])
		if d < best_dist:
			best_dist = d
			closest = i

	return closest

func random_path_point() -> int:
	return randi_range(0, path_points.size()-1)

func get_tile_under_character() -> Vector3i:
	var params = PhysicsRayQueryParameters3D.new()

	params.from = global_transform.origin + Vector3(0, 1, 0)
	params.to = global_transform.origin + Vector3(0, -5, 0)
	params.collide_with_areas = false
	params.collide_with_bodies = true
	params.set_collision_mask(1)
	params.hit_back_faces = false
	
	var space_state = get_world_3d().direct_space_state
	var hit = space_state.intersect_ray(params)

	if hit and hit.collider == gridmap:
		var local = gridmap.to_local(hit.position)
		return gridmap.local_to_map(local)

	return Vector3i(-999, -999, -999)  # no tile


func _on_debug_timer_timeout() -> void:
	print("Villager Likes:" + str(likes))
