class_name TileType
extends Resource

# Was macht ein Tile aus? -> Hat einen Einfluss auf Villager und kann ggf. kombiniert werden
# Ein Tile motiviert ein bestimmtes Product
# Eine Tile hat auch eine Position! -> ABER: wir definieren TileTYPE

# a tile-manager will create, replace, delete tiles depending on the tiletypes he knows

@export_subgroup("General")
@export var id: String
@export var description: String

@export_subgroup("Balancing")
@export var modules: Array[TileModule] = []

@export_subgroup("Rendering")
@export_range(0,999) var mesh_library_index: int
