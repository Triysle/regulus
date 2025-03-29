extends Node
class_name PlayerInteraction

signal resource_collected(resource_name, amount)
signal interaction_detected(interactable, action_text)
signal interaction_ended()

# Interaction parameters
@export var interaction_distance: float = 3.0
@export var interaction_check_frequency: float = 0.1  # How often to check for interactables (seconds)

# References
var player: CharacterBody3D
var camera: Camera3D
@onready var interaction_timer = $InteractionTimer

# Interactable tracking
var current_interactable = null

# Inventory
var inventory: Dictionary = {"Unobtanium": 0}

func _ready():
	# Using an onready timer assumes you've added this as a node in the editor
	if !interaction_timer:
		interaction_timer = Timer.new()
		interaction_timer.name = "InteractionTimer"
		interaction_timer.wait_time = interaction_check_frequency
		interaction_timer.autostart = true
		add_child(interaction_timer)
	
	interaction_timer.timeout.connect(_on_interaction_check)

func initialize(player_node: CharacterBody3D, camera_node: Camera3D):
	player = player_node
	camera = camera_node

func _on_interaction_check():
	check_for_interactable()

func check_for_interactable() -> bool:
	# Cast a ray to detect interactable objects
	var space_state = player.get_world_3d().direct_space_state
	var cam = camera.global_transform
	var ray_origin = cam.origin
	var ray_end = ray_origin + cam.basis.z * -interaction_distance
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.exclude = [player]
	query.collide_with_areas = false
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	
	# Clear previous interactable if we didn't hit anything
	if !result:
		if current_interactable != null:
			current_interactable = null
			emit_signal("interaction_ended")
		return false
	
	# Get the actual interactable object - could be the collider itself or its parent
	var potential_interactable = result.collider
	
	# Check if we hit a CollisionShape3D or StaticBody3D
	if potential_interactable is CollisionShape3D:
		potential_interactable = potential_interactable.get_parent()
	
	if potential_interactable is StaticBody3D:
		potential_interactable = potential_interactable.get_parent()
	
	# Check if the object is interactable
	if potential_interactable.has_method("interact"):
		# Check if it's a new interactable
		if current_interactable != potential_interactable:
			current_interactable = potential_interactable
			
			# Determine the interaction action text
			var action_text = "interact"
			
			# Check for special interactable types
			if current_interactable.has_method("get_interaction_text"):
				action_text = current_interactable.get_interaction_text()
			
			# Signal that an interactable is detected
			emit_signal("interaction_detected", current_interactable, action_text)
		
		return true
	else:
		# Not an interactable, clear if we had one before
		if current_interactable != null:
			current_interactable = null
			emit_signal("interaction_ended")
		
		return false

func interact() -> bool:
	# First update our interaction check
	check_for_interactable()
	
	# If we have an interactable, interact with it
	if current_interactable and current_interactable.has_method("interact"):
		return current_interactable.interact(player)
	
	return false

func collect_resource(resource_name: String, amount: int) -> int:
	if inventory.has(resource_name):
		inventory[resource_name] += amount
	else:
		inventory[resource_name] = amount
	
	emit_signal("resource_collected", resource_name, amount)
	return inventory[resource_name]

func get_inventory() -> Dictionary:
	return inventory
