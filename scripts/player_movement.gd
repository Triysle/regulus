extends Node
class_name PlayerMovement

signal jump_started
signal landed

# Movement parameters
@export var walking_speed: float = 3.0
@export var jogging_speed: float = 5.0
@export var sprinting_speed: float = 8.0
@export var crouching_speed: float = 2.0
@export var acceleration: float = 10.0
@export var deceleration: float = 15.0

# Jump parameters
@export var jump_height: float = 4.5
@export var crouch_jump_height: float = 3.0
@export var jump_cooldown: float = 0.2

# Crouch parameters
@export var standing_height: float = 1.8
@export var crouching_height: float = 0.9
@export var camera_standing_height: float = 1.7
@export var camera_crouching_height: float = 0.9
@export var crouch_transition_speed: float = 10.0

# Movement states
var is_sprinting: bool = false
var is_walking: bool = false
var is_crouching: bool = false
var can_jump: bool = true

# Physics constants
const GRAVITY = 9.8

# References
var player: CharacterBody3D
var collision_shape: CollisionShape3D
var camera: Camera3D
var stats: PlayerStats
var jump_timer: Timer

func _ready():
	# Create jump cooldown timer
	jump_timer = Timer.new()
	jump_timer.one_shot = true
	jump_timer.wait_time = jump_cooldown
	jump_timer.timeout.connect(_on_jump_timer_timeout)
	add_child(jump_timer)

func initialize(player_node: CharacterBody3D, camera_node: Camera3D, collision_node: CollisionShape3D, stats_node: PlayerStats):
	player = player_node
	camera = camera_node
	collision_shape = collision_node
	stats = stats_node
	
	# Set initial collision shape height
	if collision_shape and collision_shape.shape is CapsuleShape3D:
		collision_shape.shape.height = standing_height
		collision_shape.position.y = standing_height / 2

func process_movement(delta: float, input_dir: Vector2, third_person_mode: bool) -> Dictionary:
	var state = {
		"velocity": player.velocity,
		"is_on_floor": player.is_on_floor(),
		"is_walking": is_walking,
		"is_sprinting": is_sprinting,
		"is_crouching": is_crouching
	}
	
	# Apply gravity
	if !player.is_on_floor():
		player.velocity.y -= GRAVITY * delta
		emit_signal("landed", false)
	elif state.get("was_in_air", false):
		emit_signal("landed", true)
	
	# Calculate movement direction based on camera orientation
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Determine movement state and speed
	var target_speed = jogging_speed
	
	# Walking state (handled as a toggle)
	if is_walking:
		target_speed = walking_speed
		is_sprinting = false
	
	# Sprinting state - only if not walking or crouching
	if Input.is_action_pressed("sprint") and !is_walking and !is_crouching and stats.can_use_stamina():
		is_sprinting = true
		target_speed = sprinting_speed
		
		# Drain stamina while sprinting
		if !stats.use_stamina(delta):
			is_sprinting = false
	else:
		is_sprinting = false
	
	# Crouching state
	if is_crouching:
		target_speed = crouching_speed
		is_sprinting = false
	
	# Apply movement
	if direction:
		# Accelerate to target speed
		player.velocity.x = lerp(player.velocity.x, direction.x * target_speed, acceleration * delta)
		player.velocity.z = lerp(player.velocity.z, direction.z * target_speed, acceleration * delta)
	else:
		# Decelerate to stop
		player.velocity.x = lerp(player.velocity.x, 0.0, deceleration * delta)
		player.velocity.z = lerp(player.velocity.z, 0.0, deceleration * delta)
	
	# Return updated state information for animation system
	state["velocity"] = player.velocity
	state["is_walking"] = is_walking
	state["is_sprinting"] = is_sprinting
	state["is_crouching"] = is_crouching
	state["was_in_air"] = !player.is_on_floor()
	
	return state

func jump():
	if player.is_on_floor() and can_jump:
		can_jump = false
		jump_timer.start()
		
		# Emit signal for animation
		emit_signal("jump_started")
		
		# Determine jump height based on crouch state
		var jump_velocity = sqrt(2 * GRAVITY * (crouch_jump_height if is_crouching else jump_height))
		player.velocity.y = jump_velocity

func toggle_crouch(third_person_mode: bool):
	is_crouching = !is_crouching
	_update_crouch_state(third_person_mode)

func toggle_walk():
	is_walking = !is_walking
	# Can't sprint while walking
	if is_walking:
		is_sprinting = false

func _update_crouch_state(third_person_mode: bool):
	var capsule = collision_shape.shape as CapsuleShape3D
	if !capsule:
		return
	
	if is_crouching:
		# Reduce collision shape height
		capsule.height = crouching_height
		collision_shape.position.y = crouching_height / 2
		
		# Only adjust camera in first-person mode
		if !third_person_mode:
			# Lower camera position
			camera.position.y = camera_crouching_height
			
			# Notify camera controller of position change
			if camera.has_method("update_base_position"):
				camera.update_base_position(Vector3(0, camera_crouching_height, 0))
	else:
		# Check if there's enough room to stand up
		var space_state = player.get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(player.global_position, player.global_position + Vector3.UP * standing_height)
		query.exclude = [player]
		var result = space_state.intersect_ray(query)
		
		if result:
			# Can't stand up, stay crouched
			is_crouching = true
			return
			
		# Return to normal height
		capsule.height = standing_height
		collision_shape.position.y = standing_height / 2
		
		# Only adjust camera in first-person mode
		if !third_person_mode:
			# Reset camera position
			camera.position.y = camera_standing_height
			
			# Notify camera controller of position change
			if camera.has_method("update_base_position"):
				camera.update_base_position(Vector3(0, camera_standing_height, 0))

func _on_jump_timer_timeout():
	can_jump = true
