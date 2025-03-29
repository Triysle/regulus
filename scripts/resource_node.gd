extends Node3D

# Resource properties
@export var resource_amount: int = 10
@export var resource_name: String = "Unobtanium"
@export var respawn_time: float = 30.0

# Visual feedback
@export var active_material: Material
@export var depleted_material: Material

# Node references
@onready var mesh_instance = $MeshInstance3D
@onready var collision_shape = $StaticBody3D/CollisionShape3D
@onready var respawn_timer = $RespawnTimer

var is_depleted: bool = false

func _ready():
	respawn_timer.wait_time = respawn_time
	respawn_timer.one_shot = true
	
	if mesh_instance and active_material:
		mesh_instance.material_override = active_material
		
	# Connect the respawn timer timeout signal
	if !respawn_timer.is_connected("timeout", _on_respawn_timer_timeout):
		respawn_timer.connect("timeout", _on_respawn_timer_timeout)

# Called when player interacts with this node via raycast
func interact(player):
	if is_depleted:
		print("Resource is depleted")
		return false
		
	if player.has_method("collect_resource"):
		player.collect_resource(resource_name, resource_amount)
		deplete()
		return true
	return false

# Return custom interaction text for this node
func get_interaction_text() -> String:
	if is_depleted:
		return "examine depleted " + resource_name
	else:
		return "collect " + resource_name

func deplete():
	is_depleted = true
	
	if mesh_instance and depleted_material:
		mesh_instance.material_override = depleted_material
	
	respawn_timer.start()

func _on_respawn_timer_timeout():
	is_depleted = false
	
	if mesh_instance and active_material:
		mesh_instance.material_override = active_material
