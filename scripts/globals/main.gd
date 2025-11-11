extends Node2D

@onready var weather_machine: Node = $WeatherStateMachine 
@onready var weather_label: Label = $UI/WeatherLabel

func _ready() -> void:
	weather_machine.weather_changed.connect(_on_weather_state_machine_weather_changed)

func _on_fire_button_pressed() -> void:
	weather_machine.cast_spell(Enums.SpellType.FIRE)

func _on_water_button_pressed() -> void:
	weather_machine.cast_spell(Enums.SpellType.WATER)

func _on_ice_button_pressed() -> void:
	weather_machine.cast_spell(Enums.SpellType.ICE)

func _on_wind_button_pressed() -> void:
	weather_machine.cast_spell(Enums.SpellType.WIND)

func _on_weather_state_machine_weather_changed(new_weather: int) -> void:
	weather_label.text = Enums.WeatherType.keys()[new_weather]
