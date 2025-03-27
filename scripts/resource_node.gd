extends Node3D

# Resource properties
@export var resource_amount: int = 10
@export var resource_name: String = "Unobtanium"
@export var respawn_time: float = 30.0  # Time in seconds to respawn

# Visual feedback
@export var active_material: Material
@export var depleted_material: Material

# Node references
@onready var mesh_instance = $MeshInstance3D
@onready var interaction_area = $InteractionArea
@onready var respawn_timer = $RespawnTimer

var is_depleted: bool = false

func _ready():
	# Set up the respawn timer
	respawn_timer.wait_time = respawn_time
	respawn_timer.one_shot = true
	
	# Ensure we're using the active material
	if mesh_instance and active_material:
		mesh_instance.material_override = active_material

# Called when player interacts with this node
func interact(player):
	if is_depleted:
		return
		
	# Give resources to player
	if player.has_method("collect_resource"):
		player.collect_resource(resource_name, resource_amount)
		
	# Deplete this node
	deplete()

func deplete():
	is_depleted = true
	
	# Change appearance to show depletion
	if mesh_instance and depleted_material:
		mesh_instance.material_override = depleted_material
	
	# Start respawn timer
	respawn_timer.start()

func _on_respawn_timer_timeout():
	# Restore the node
	is_depleted = false
	
	# Change appearance back to active
	if mesh_instance and active_material:
		mesh_instance.material_override = active_material
