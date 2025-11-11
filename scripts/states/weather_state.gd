extends Node
class_name WeatherState

var machine: Node = null

func enter() -> void:
	pass

func exit() -> void:
	pass

func _process(delta: float) -> void:
	pass

func handle_spell(spell: int) -> int:
	return Enums.SpellType.NONE
