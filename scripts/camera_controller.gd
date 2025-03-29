extends Camera3D

# Head bob parameters
@export var bob_enabled: bool = true
@export var bob_frequency: float = 2.0
@export var bob_amplitude: float = 0.08
@export var bob_max_travel: float = 0.1

# Camera position smoothing
@export var position_smoothing: bool = true
@export var position_smoothing_speed: float = 10.0

# FOV settings
@export var base_fov: float = 75.0
@export var sprint_fov_multiplier: float = 1.1
@export var fov_change_speed: float = 4.0

# Internal variables
var bob_time: float = 0.0
var initial_position: Vector3
var target_fov: float = base_fov

func _ready():
	initial_position = position

func _process(delta):
	var player = get_parent() as Player
	
	if player:
		_handle_head_bob(delta, player)
		_handle_fov_changes(delta, player)

func _handle_head_bob(delta: float, player: Player):
	if !bob_enabled:
		return
		
	# Only bob when moving on the ground
	if player.is_on_floor() and (abs(player.velocity.x) > 0.1 or abs(player.velocity.z) > 0.1):
		# Calculate speed as a percentage of sprinting speed
		var speed_factor = player.velocity.length() / player.sprinting_speed
		
		# Increase bob time based on speed
		bob_time += delta * bob_frequency * speed_factor
		
		# Calculate vertical and horizontal bob
		var bob_vertical = sin(bob_time) * bob_amplitude * speed_factor
		var bob_horizontal = cos(bob_time * 0.5) * bob_amplitude * 0.5 * speed_factor
		
		# Apply bob to position, but keep within bounds
		var target_position = initial_position + Vector3(
			clamp(bob_horizontal, -bob_max_travel, bob_max_travel),
			clamp(bob_vertical, -bob_max_travel, bob_max_travel),
			0
		)
		
		# Apply smoothing if enabled
		if position_smoothing:
			position = position.lerp(target_position, delta * position_smoothing_speed)
		else:
			position = target_position
	else:
		# Reset position when not moving or in air
		bob_time = 0
		
		if position_smoothing:
			position = position.lerp(initial_position, delta * position_smoothing_speed)
		else:
			position = initial_position

func _handle_fov_changes(delta: float, player: Player):
	# Set target FOV based on player state
	if player.is_sprinting:
		target_fov = base_fov * sprint_fov_multiplier
	else:
		target_fov = base_fov
	
	# Smoothly transition FOV
	fov = lerp(fov, target_fov, delta * fov_change_speed)

# Call this when the camera position changes (e.g., when crouching/standing)
func update_base_position(new_position: Vector3):
	initial_position = new_position
	position = new_position
