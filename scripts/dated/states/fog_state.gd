extends WeatherState

func enter() -> void:
	print("Weather: White fog")
	machine.emit_signal("weather_changed", Enums.WeatherType.FOG)

func handle_spell(spell: int) -> int:
	match spell:
		Enums.SpellType.ICE:
			return Enums.WeatherType.RAIN
		Enums.SpellType.WATER:
			return Enums.WeatherType.THUNDER
		Enums.SpellType.WIND:
			return Enums.WeatherType.HOT
		_:
			return -1
