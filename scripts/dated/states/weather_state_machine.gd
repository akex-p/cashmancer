extends Node
class_name WeatherSystem

signal weather_changed(new_weather: int)

var states: Dictionary = {}
var current_state: WeatherState = null
var current_state_enum: int = Enums.WeatherType.CLEAR

func _ready() -> void:
	# Collect all WeatherState children automatically
	for child in get_children():
		if child is WeatherState:
			states[_get_enum_from_name(child.name)] = child
			child.machine = self

	# Start in CLEAR
	change_state(Enums.WeatherType.CLEAR)

func change_state(new_state: int) -> void:
	if current_state:
		current_state.exit()

	current_state_enum = new_state
	current_state = states.get(new_state)
	if current_state:
		current_state.enter()

func cast_spell(spell: int) -> void:
	if not current_state:
		return
	var next_state = current_state.handle_spell(spell)
	if next_state != -1 and states.has(next_state):
		change_state(next_state)

# Helper to map child node names to enums automatically
func _get_enum_from_name(node_name: String) -> int:
	match node_name.to_lower():
		"clearstate": return Enums.WeatherType.CLEAR
		"rainstate": return Enums.WeatherType.RAIN
		"snowstate": return Enums.WeatherType.SNOW
		"thunderstate": return Enums.WeatherType.THUNDER
		"floodstate": return Enums.WeatherType.FLOOD
		"blizzardstate": return Enums.WeatherType.BLIZZARD
		"hotstate": return Enums.WeatherType.HOT
		"fogstate": return Enums.WeatherType.FOG
		"coldstate": return Enums.WeatherType.COLD
		_: return Enums.WeatherType.CLEAR
