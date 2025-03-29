extends Node
class_name PlayerInteraction

signal resource_collected(resource_name, amount)

# Interaction parameters
@export var interaction_distance: float = 3.0

# References
var player: CharacterBody3D
var camera: Camera3D

# Inventory
var inventory: Dictionary = {"Unobtanium": 0}

func _ready():
	pass

func initialize(player_node: CharacterBody3D, camera_node: Camera3D):
	player = player_node
	camera = camera_node

func interact():
	# Cast a ray to detect interactable objects
	var space_state = player.get_world_3d().direct_space_state
	var cam = camera.global_transform
	var ray_origin = cam.origin
	var ray_end = ray_origin + cam.basis.z * -interaction_distance
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.exclude = [player]
	var result = space_state.intersect_ray(query)
	
	if result and result.collider.has_method("interact"):
		result.collider.interact(player)
		return true
	
	return false

func collect_resource(resource_name: String, amount: int):
	if inventory.has(resource_name):
		inventory[resource_name] += amount
	else:
		inventory[resource_name] = amount
	
	emit_signal("resource_collected", resource_name, amount)
	return inventory[resource_name]

func get_inventory() -> Dictionary:
	return inventory
