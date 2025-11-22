extends WeatherState
class_name RainState

func enter() -> void:
	print("Weather: Getting wet")
	machine.emit_signal("weather_changed", Enums.WeatherType.RAIN)

func handle_spell(spell: int) -> int:
	match spell:
		Enums.SpellType.FIRE:
			return Enums.WeatherType.FOG
		Enums.SpellType.ICE:
			return Enums.WeatherType.SNOW
		Enums.SpellType.WATER:
			return Enums.WeatherType.FLOOD
		Enums.SpellType.WIND:
			return Enums.WeatherType.CLEAR
		_:
			return -1
