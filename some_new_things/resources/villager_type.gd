class_name VillagerType
extends Resource

@export_subgroup("General")
@export var id: String
@export var description: String

@export_subgroup("Stats")
@export var speed: float = 100.0
@export var sight_range: float = 1.0   # how far it can "see" tiles (optional)

@export_subgroup("Frustration")
@export var frustration_increment: float = 1.0
@export var frustration_threshold: float = 5.0

@export_subgroup("Preferences")
@export var preferred_products: Dictionary[ProductType, float]
@export var preferred_tiles: Dictionary[TileType, float]

#@export_subgroup("BehaviorModules")
#@export var modules: Array[VillagerModule]
