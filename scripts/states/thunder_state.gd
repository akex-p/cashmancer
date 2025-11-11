extends WeatherState

func enter() -> void:
	print("Weather: Thunder roaring")
	machine.emit_signal("weather_changed", Enums.WeatherType.THUNDER)

func handle_spell(spell: int) -> int:
	match spell:
		Enums.SpellType.ICE:
			return Enums.WeatherType.FLOOD
		Enums.SpellType.WIND:
			return Enums.WeatherType.FOG
		_:
			return -1
