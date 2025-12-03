class_name TileModuleEvent
extends TileModule

@export_enum("Teleport", "Explode", "Heal", "Charm", "Stun") var effect_type: String = "Teleport"

@export var effect_strength: float = 1.0
@export var effect_radius: float = 0.0 # do we need something like that??
