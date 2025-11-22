extends Control
class_name PlayerCursor

# resolution set to 640x480

enum ActionType {
	FIRE,
	WIND,
	WATER
}

@export var CUROR_SPEED: float = 400.0

@onready var grab_hand_texture: TextureRect = $HandTexture/GrabHandTexture
@onready var open_hand_texture: TextureRect = $HandTexture/OpenHandTexture
@onready var action_texture: TextureRect = $Control/BannerTexture/ActionTexture

@onready var fire_texture: CompressedTexture2D = load("res://assets/sprite/action_fire.png")
@onready var wind_texture: CompressedTexture2D = load("res://assets/sprite/action_wind.png")
@onready var water_texture: CompressedTexture2D = load("res://assets/sprite/action_water.png")

signal grabbing(action_type: ActionType)
signal dropping

var cur_action = ActionType.FIRE

func _physics_process(delta: float) -> void:
	# movement
	var input_direction = Input.get_vector("cursor_left_1", "cursor_right_1", "cursor_up_1", "cursor_down_1")
	if input_direction:
		position += input_direction * delta * CUROR_SPEED
	
	# grabbing
	if Input.is_action_just_pressed("grab_1"):
		set_grab_hand_texture(true)
		grabbing.emit(cur_action)
		print("Initiated Grab")
	
	if Input.is_action_just_released("grab_1"):
		set_grab_hand_texture(false)
		dropping.emit()
		print("Released Grab")
	
	if Input.is_action_just_pressed("next_action_1"):
		set_next_action()
		
	if Input.is_action_just_pressed("prev_action_1"):
		set_prev_action()

func set_grab_hand_texture(set_texture: bool):
	grab_hand_texture.visible = set_texture
	open_hand_texture.visible = !set_texture

func set_next_action():
	set_cur_action((cur_action + 1) % 3)

func set_prev_action():
	var prev_action = cur_action - 1
	if prev_action == -1:
		prev_action = 2
	set_cur_action(prev_action)

func set_cur_action(action: ActionType):
	match action:
		ActionType.FIRE:
			cur_action = ActionType.FIRE
			action_texture.texture = fire_texture
		ActionType.WIND:
			cur_action = ActionType.WIND
			action_texture.texture = wind_texture
		ActionType.WATER:
			cur_action = ActionType.WATER
			action_texture.texture = water_texture
