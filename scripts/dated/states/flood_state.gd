extends WeatherState

func enter() -> void:
	print("Weather: Water everywhere")
	machine.emit_signal("weather_changed", Enums.WeatherType.FLOOD)

func handle_spell(spell: int) -> int:
	match spell:
		Enums.SpellType.FIRE:
			return Enums.WeatherType.THUNDER
		Enums.SpellType.ICE:
			return Enums.WeatherType.BLIZZARD
		Enums.SpellType.WIND:
			return Enums.WeatherType.RAIN
		_:
			return -1
