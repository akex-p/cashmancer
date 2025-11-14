extends Node3D

@onready var barbarian_scene: PackedScene = preload("res://assets/char/barbarian/Barbarian.tscn")

func _on_button_pressed() -> void:
	var instance = barbarian_scene.instantiate()
	add_child(instance)

func _on_button_2_pressed() -> void:
	for n in 10:
		var instance = barbarian_scene.instantiate()
		add_child(instance)
