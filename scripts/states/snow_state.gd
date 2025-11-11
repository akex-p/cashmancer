extends WeatherState

func enter() -> void:
	print("Weather: Snow falling")
	machine.emit_signal("weather_changed", Enums.WeatherType.SNOW)

func handle_spell(spell: int) -> int:
	match spell:
		Enums.SpellType.FIRE:
			return Enums.WeatherType.RAIN
		Enums.SpellType.WATER:
			return Enums.WeatherType.BLIZZARD
		Enums.SpellType.WIND:
			return Enums.WeatherType.COLD
		_:
			return -1
