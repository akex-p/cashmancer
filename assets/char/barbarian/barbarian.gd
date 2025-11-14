extends CharacterBody3D

@export var SPEED: float = 5.0
@export var SWITCH_DIRECTION_MAX: int = 4
@export var SWITCH_DIRECTION_MIN: int = 1
@export var PAUSE_WALK_MAX: int = 4
@export var PAUSE_WALK_MIN: int = 1
@export var ROTATION_SPEED: float = 10.0

@onready var switch_direction_timer: Timer = $SwitchDirectionTimer
@onready var pause_walk_timer: Timer = $PauseWalkTimer

var is_walking: bool = false
var input_dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	set_random_direction()

func _physics_process(delta: float) -> void:
	
	rotation.y = lerp_angle(rotation.y, atan2(input_dir.x, input_dir.y), delta * ROTATION_SPEED)
	
	if is_walking:
		if input_dir:
			velocity.x = input_dir.x * SPEED
			velocity.z = input_dir.y * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()

func _on_switch_direction_timer_timeout() -> void:
	set_random_direction()
	switch_direction_timer.wait_time = randi_range(SWITCH_DIRECTION_MIN, SWITCH_DIRECTION_MAX)
	switch_direction_timer.start()

func set_random_direction() -> void:
	input_dir = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()

func _on_pause_walk_timer_timeout() -> void:
	pause_and_unpause()
	pause_walk_timer.wait_time = randi_range(PAUSE_WALK_MIN, PAUSE_WALK_MAX)
	pause_walk_timer.start()

func pause_and_unpause() -> void:
	is_walking = !is_walking
