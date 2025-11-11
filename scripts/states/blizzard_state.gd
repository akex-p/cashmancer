extends WeatherState

func enter() -> void:
	print("Weather: Frosty blizzard")
	machine.emit_signal("weather_changed", Enums.WeatherType.BLIZZARD)

func handle_spell(spell: int) -> int:
	match spell:
		Enums.SpellType.FIRE:
			return Enums.WeatherType.FLOOD
		Enums.SpellType.WIND:
			return Enums.WeatherType.SNOW
		_:
			return -1
