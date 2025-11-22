extends Node2D

@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var weather_machine: Node = $"../WeatherStateMachine"

func _ready() -> void:
	weather_machine.weather_changed.connect(_on_weather_state_machine_weather_changed)
	_update_weather(Enums.WeatherType.CLEAR)

func _update_weather(type: Enums.WeatherType):
	match type:
		Enums.WeatherType.HOT:
			_set_particle_settings(Color(1.0, 0.8, 0.4, 0.2), 1.0, 50, 10.0,0.5)
		Enums.WeatherType.COLD:
			_set_particle_settings(Color(0.8, 0.9, 1.0, 0.2), 1.5, 100, 15.0, 0.6)
		Enums.WeatherType.CLEAR:
			particles.emitting = false
		Enums.WeatherType.FOG:
			_set_particle_settings(Color(0.9, 0.9, 0.9, 0.1), 3.0, 200, 5.0, 2.0)
		Enums.WeatherType.RAIN:
			_set_particle_settings(Color(0.6, 0.6, 0.9, 0.8), 1.2, 400, 300.0, 0.2)
		Enums.WeatherType.SNOW:
			_set_particle_settings(Color(1.0, 1.0, 1.0, 0.9), 4.0, 150, 60.0, 0.4)
		Enums.WeatherType.THUNDER:
			_set_particle_settings(Color(0.8, 0.8, 1.0, 0.7), 0.8, 200, 250.0, 0.3)
		Enums.WeatherType.FLOOD:
			_set_particle_settings(Color(0.3, 0.4, 0.8, 0.7), 2.0, 500, 100.0, 0.3)
		Enums.WeatherType.BLIZZARD:
			_set_particle_settings(Color(0.95, 0.95, 1.0, 0.9), 3.0, 500, 200.0, 0.5)

func _set_particle_settings(emission_color: Color, lifetime: float, amount: int, speed: float, _scale: float) -> void:
	particles.emitting = true
	particles.amount = amount
	particles.lifetime = lifetime
	particles.initial_velocity_min = speed * 0.8
	particles.initial_velocity_max = speed
	particles.scale_amount_min = _scale * 0.8
	particles.scale_amount_max = _scale
	particles.color = emission_color

	var screen_size = get_viewport_rect().size
	particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	particles.emission_rect_extents = Vector2(screen_size.x / 2, 10)
	particles.position = Vector2(screen_size.x / 2, -10)

func _on_weather_state_machine_weather_changed(new_weather: int) -> void:
	_update_weather(new_weather)
