extends WeatherState

func enter() -> void:
	print("Weather: Clear skies")
	machine.emit_signal("weather_changed", Enums.WeatherType.CLEAR)

func handle_spell(spell: int) -> int:
	match spell:
		Enums.SpellType.FIRE:
			return Enums.WeatherType.HOT
		Enums.SpellType.WATER:
			return Enums.WeatherType.RAIN
		Enums.SpellType.ICE:
			return Enums.WeatherType.COLD
		_:
			return -1
