extends WeatherState

func enter() -> void:
	print("Weather: Getting hot")
	machine.emit_signal("weather_changed", Enums.WeatherType.HOT)

func handle_spell(spell: int) -> int:
	match spell:
		Enums.SpellType.ICE:
			return Enums.WeatherType.CLEAR
		Enums.SpellType.WATER:
			return Enums.WeatherType.FOG
		_:
			return -1
