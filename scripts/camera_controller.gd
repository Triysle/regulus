extends Camera3D

# FOV settings
@export var base_fov: float = 75.0
@export var sprint_fov_multiplier: float = 1.1
@export var fov_change_speed: float = 4.0

# Internal variables
var target_fov: float = base_fov

func _ready():
	# Set initial FOV
	fov = base_fov

func _process(delta):
	var player = get_parent() as Player
	
	if player:
		_handle_fov_changes(delta, player)

func _handle_fov_changes(delta: float, player: Player):
	# Set target FOV based on player state
	if player.movement_handler and player.movement_handler.is_sprinting:
		target_fov = base_fov * sprint_fov_multiplier
	else:
		target_fov = base_fov
	
	# Smoothly transition FOV
	fov = lerp(fov, target_fov, delta * fov_change_speed)

# Call this when the camera position changes (e.g., when crouching/standing)
func update_base_position(new_position: Vector3):
	position = new_position
