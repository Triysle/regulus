extends CharacterBody3D

class_name Player

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

# Mouse sensitivity
@export var mouse_sensitivity: float = 0.003

# Health and shield parameters
@export var max_health: float = 100.0
@export var max_shield: float = 100.0
@export var shield_regen_rate: float = 5.0  # Shield points per second
@export var shield_regen_delay: float = 3.0  # Seconds after damage before regen starts

# Stamina parameters
@export var max_stamina: float = 100.0
@export var stamina_regen_rate: float = 10.0  # Per second
@export var stamina_drain_rate: float = 15.0  # Per second
@export var stamina_recovery_delay: float = 1.5  # After fully depleted

# Crouch parameters
@export var standing_height: float = 1.8
@export var crouching_height: float = 0.9
@export var camera_standing_height: float = 1.7
@export var camera_crouching_height: float = 0.9
@export var crouch_transition_speed: float = 10.0

# Current states
var health: float = max_health
var shield: float = max_shield
var stamina: float = max_stamina

var is_sprinting: bool = false
var is_walking: bool = false
var is_crouching: bool = false
var last_damage_time: float = 0.0
var stamina_depleted_time: float = 0.0
var can_jump: bool = true
var inventory: Dictionary = {"Unobtanium": 0}

# Node references
@onready var camera = $Camera3D
@onready var collision_shape = $CollisionShape3D
@onready var weapon_manager = $Camera3D/WeaponManager
@onready var hud = $CanvasLayer/PlayerHud

# Jump cooldown timer
var jump_timer: Timer

# Physics constants
const GRAVITY = 9.8

func _ready():
	# Lock mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Create jump cooldown timer
	jump_timer = Timer.new()
	jump_timer.one_shot = true
	jump_timer.wait_time = jump_cooldown
	jump_timer.timeout.connect(_on_jump_timer_timeout)
	add_child(jump_timer)
	
	# Initialize HUD
	hud.update_display(shield, max_shield, health, max_health)
	hud.update_resources(inventory)
	
	# Connect weapon manager signals
	if weapon_manager:
		weapon_manager.weapon_fired.connect(_on_weapon_fired)
		weapon_manager.weapon_switched.connect(_on_weapon_switched)
	
	# Ensure collision shape is properly set
	if collision_shape and collision_shape.shape is CapsuleShape3D:
		collision_shape.shape.height = standing_height
		collision_shape.position.y = standing_height / 2

func _input(event):
	# Only process input if mouse is captured
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		if event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		return
	
	# Handle mouse movement for camera control
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	# Toggle mouse capture with escape key
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Interact with objects
	if event.is_action_pressed("interact"):
		_interact()
	
	# Toggle crouch
	if event.is_action_pressed("crouch"):
		is_crouching = !is_crouching
		_update_crouch_state()
	
	# Toggle walk
	if event.is_action_pressed("walk"):
		is_walking = !is_walking
		# Can't sprint while walking
		if is_walking:
			is_sprinting = false

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	
	# Calculate movement direction based on camera orientation
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Determine movement state and speed
	var target_speed = jogging_speed
	
	# Walking state (handled as a toggle now)
	if is_walking:
		target_speed = walking_speed
		is_sprinting = false
	
	# Sprinting state - only if not walking or crouching
	if Input.is_action_pressed("sprint") and !is_walking and !is_crouching and stamina > 0:
		is_sprinting = true
		target_speed = sprinting_speed
		
		# Drain stamina while sprinting
		stamina = max(0, stamina - stamina_drain_rate * delta)
		if stamina == 0:
			stamina_depleted_time = Time.get_ticks_msec() / 1000.0
			is_sprinting = false
	else:
		is_sprinting = false
	
	# Crouching state
	if is_crouching:
		target_speed = crouching_speed
		is_sprinting = false
	
	# Stamina regeneration when not sprinting
	if !is_sprinting:
		var current_time = Time.get_ticks_msec() / 1000.0
		if current_time - stamina_depleted_time > stamina_recovery_delay or stamina > 0:
			stamina = min(max_stamina, stamina + stamina_regen_rate * delta)
	
	# Apply movement
	if direction:
		# Accelerate to target speed
		velocity.x = lerp(velocity.x, direction.x * target_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * target_speed, acceleration * delta)
	else:
		# Decelerate to stop
		velocity.x = lerp(velocity.x, 0.0, deceleration * delta)
		velocity.z = lerp(velocity.z, 0.0, deceleration * delta)
	
	# Handle jumping
	if Input.is_action_just_pressed("jump") and is_on_floor() and can_jump:
		can_jump = false
		jump_timer.start()
		
		# Determine jump height based on crouch state
		var jump_velocity = sqrt(2 * GRAVITY * (crouch_jump_height if is_crouching else jump_height))
		velocity.y = jump_velocity
	
	# Shield regeneration
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_damage_time > shield_regen_delay:
		shield = min(max_shield, shield + shield_regen_rate * delta)
		hud.update_display(shield, max_shield, health, max_health)
	
	# Move the character
	move_and_slide()
	
	# Update animation states (in a full implementation)
	_update_animations(delta)

func _update_animations(delta):
	# This is a placeholder for animation state management
	# In a full implementation, you would set animation states based on
	# movement, crouching, jumping, etc.
	
	# Example of how you might structure this:
	var anim_state = "idle"
	
	if !is_on_floor():
		anim_state = "jump"
	elif is_crouching:
		if abs(velocity.x) > 0.1 or abs(velocity.z) > 0.1:
			anim_state = "crouch_walk"
		else:
			anim_state = "crouch_idle"
	else:
		if is_sprinting:
			anim_state = "sprint"
		elif is_walking:
			anim_state = "walk"
		elif abs(velocity.x) > 0.1 or abs(velocity.z) > 0.1:
			anim_state = "jog"
		else:
			anim_state = "idle"
	
	# When you have an AnimationTree, you would set parameters like:
	# animation_tree["parameters/state/transition"] = anim_state

func _update_crouch_state():
	var capsule = collision_shape.shape as CapsuleShape3D
	if !capsule:
		return
	
	if is_crouching:
		# Reduce collision shape height
		capsule.height = crouching_height
		collision_shape.position.y = crouching_height / 2
		# Lower camera position
		camera.position.y = camera_crouching_height
		
		# Notify camera controller of position change
		if camera.has_method("update_base_position"):
			camera.update_base_position(Vector3(0, camera_crouching_height, 0))
	else:
		# Check if there's enough room to stand up
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(global_position, global_position + Vector3.UP * standing_height)
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		
		if result:
			# Can't stand up, stay crouched
			is_crouching = true
			return
			
		# Return to normal height
		capsule.height = standing_height
		collision_shape.position.y = standing_height / 2
		# Reset camera position
		camera.position.y = camera_standing_height
		
		# Notify camera controller of position change
		if camera.has_method("update_base_position"):
			camera.update_base_position(Vector3(0, camera_standing_height, 0))

func _interact():
	# Cast a ray to detect interactable objects
	var space_state = get_world_3d().direct_space_state
	var cam = camera.global_transform
	var ray_origin = cam.origin
	var ray_end = ray_origin + cam.basis.z * -3.0 # 3 meter interaction distance
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	
	if result and result.collider.has_method("interact"):
		result.collider.interact(self)

func _on_jump_timer_timeout():
	can_jump = true

func _on_weapon_fired(weapon_data):
	# Handle weapon recoil, sfx, etc.
	# For now, just print info
	print("Fired weapon: " + weapon_data.name)
	
	# Apply camera recoil (example)
	# camera.rotation.x -= 0.02

func _on_weapon_switched(weapon_data):
	# Update HUD or handle weapon switch effects
	print("Switched to weapon: " + weapon_data.name)

func take_damage(amount: float):
	# Record time of damage for shield regeneration delay
	last_damage_time = Time.get_ticks_msec() / 1000.0
	
	# Damage is applied to shield first, then health
	if shield > 0:
		if shield >= amount:
			shield -= amount
			amount = 0
		else:
			amount -= shield
			shield = 0
	
	if amount > 0:
		health -= amount
	
	# Check for death
	if health <= 0:
		_die()
	
	# Update HUD
	hud.update_display(shield, max_shield, health, max_health)

func _die():
	# Handle player death
	print("Player died!")
	# Implement death handling here
	# For example, show death screen, respawn, etc.
	
	# This is a placeholder implementation
	health = max_health
	shield = max_shield
	global_position = Vector3(0, 2, 0)  # Reset position

func collect_resource(resource_name: String, amount: int):
	if inventory.has(resource_name):
		inventory[resource_name] += amount
	else:
		inventory[resource_name] = amount
	
	print("Collected " + str(amount) + " " + resource_name)
	hud.update_resources(inventory)

func get_current_weapon():
	if weapon_manager:
		return weapon_manager.weapons[weapon_manager.current_weapon_index]
	return null
