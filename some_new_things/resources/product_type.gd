class_name ProductType
extends Resource

# Ein Produkt gibt dem Spieler eine Resistenz und ist nach einer bestimmten Zeit wieder weg
# es kann auch disposable sein, d.h. one-time-use

# later on, a product-manager will be filled with ProductTypes and it will give those to players

@export_subgroup("General")
@export var id: String
@export var description: String

@export_subgroup("Balancing")
@export_range(0, 999.0) var decay_time: float = 20.0
@export var is_disposable: bool = false

@export_subgroup("Rendering")
@export var mesh_instance: PackedScene
