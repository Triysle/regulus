extends Node3D

@export var damage_amount: float = 10.0
@export var interaction_material: Material

@onready var mesh_instance = $MeshInstance3D
@onready var collision_shape = $StaticBody3D/CollisionShape3D

func _ready():
	if interaction_material and mesh_instance:
		mesh_instance.material_override = interaction_material

func interact(player):
	# Apply damage to the player
	if player.has_method("take_damage"):
		player.take_damage(damage_amount)
		print("Applied " + str(damage_amount) + " damage")
		return true
	return false

# Return custom interaction text for this damage object
func get_interaction_text() -> String:
	return "test damage (" + str(damage_amount) + ")"
