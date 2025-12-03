class_name ActionType
extends Resource

# an action has LOTS of DIFFERENT functionality... so modules are perfect?
# combination -> look at current tiletype and create new tiletype
# movement -> take tiletype and move it to new place
# perhaps, interactions with villagers???? or only tiles???

@export_subgroup("General")
@export var id: String
@export var description: String

@export_subgroup("Balancing")
@export var modules: Array[ActionModule]
