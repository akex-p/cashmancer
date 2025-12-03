class_name TileModuleProduct
extends TileModule

@export_range(0, 1.0) var overall_convince_strength: float = 1.0
@export var product_convince_strength: Dictionary[ProductType, float]
