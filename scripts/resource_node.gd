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
@onready var interaction_area = $InteractionArea
@onready var respawn_timer = $RespawnTimer

var is_depleted: bool = false
var player_in_range = false
var current_player = null

func _ready():
	respawn_timer.wait_time = respawn_time
	respawn_timer.one_shot = true
	
	if mesh_instance and active_material:
		mesh_instance.material_override = active_material
	
	if interaction_area:
		interaction_area.connect("body_entered", _on_interaction_area_body_entered)
		interaction_area.connect("body_exited", _on_interaction_area_body_exited)

# Called when player interacts with this node
func interact(player):
	if is_depleted:
		return
		
	if player.has_method("collect_resource"):
		player.collect_resource(resource_name, resource_amount)
		deplete()

func deplete():
	is_depleted = true
	
	if mesh_instance and depleted_material:
		mesh_instance.material_override = depleted_material
	
	respawn_timer.start()

func _on_respawn_timer_timeout():
	is_depleted = false
	
	if mesh_instance and active_material:
		mesh_instance.material_override = active_material

# Area-based interaction methods
func _on_interaction_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		current_player = body

func _on_interaction_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		current_player = null

func _input(event):
	if event.is_action_pressed("interact") and player_in_range and current_player and not is_depleted:
		interact(current_player)
