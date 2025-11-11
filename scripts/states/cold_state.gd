extends WeatherState

func enter() -> void:
	print("Weather: Cold breeze")
	machine.emit_signal("weather_changed", Enums.WeatherType.COLD)

func handle_spell(spell: int) -> int:
	match spell:
		Enums.SpellType.FIRE:
			return Enums.WeatherType.CLEAR
		Enums.SpellType.WATER:
			return Enums.WeatherType.SNOW
		_:
			return -1
