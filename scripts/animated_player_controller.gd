extends CharacterBody3D

# Movement parameters
@export var speed = 5.0
@export var sprint_speed = 8.0
@export var jump_velocity = 4.5
@export var mouse_sensitivity = 0.002
@export var acceleration = 10.0
@export var deceleration = 20.0

# Player stats
@export var max_shield = 100.0
@export var max_health = 100.0
@export var shield_regen_rate = 5.0
@export var shield_regen_delay = 3.0

var shield = max_shield
var health = max_health
var shield_timer = 0.0

# Inventory
var inventory = {
	"Unobtanium": 0
}

# Animation states
var current_state = ""
var was_on_floor = true
var is_sprinting = false

# Node references
@onready var camera = $Camera3D
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationPlayer/AnimationTree
@onready var animation_state = null  # Will be set in _ready
@onready var interaction_ray = $Camera3D/RayCast3D

# Get the default gravity from Project Settings
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	# Initialize player
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")
	
	# Set up camera
	camera.current = true
	
	# Initialize animation tree
	animation_tree.active = true
	animation_state = animation_tree["parameters/playback"]
	
	# Start with idle animation
	animation_state.travel("Idle")
	current_state = "Idle"
	
	# Add interaction ray if it doesn't exist
	if interaction_ray == null:
		interaction_ray = RayCast3D.new()
		camera.add_child(interaction_ray)
		interaction_ray.enabled = true
		interaction_ray.target_position = Vector3(0, 0, -3)  # 3 meters forward

func _unhandled_input(event):
	# Mouse look
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	# Toggle mouse capture with Escape key
	if event.is_action_pressed("ui_cancel"):
		toggle_mouse_capture()
		get_viewport().set_input_as_handled()
		
	# Interaction
	if event.is_action_pressed("interact") and interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()
		
		if collider is CollisionShape3D:
			collider = collider.get_parent()
		
		if collider is Area3D:
			collider = collider.get_parent()
			
		if collider.has_method("interact"):
			collider.interact(self)

func toggle_mouse_capture():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Don't process if mouse is not captured
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
		
	# Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	
	# Check sprint input (using Shift key by default)
	is_sprinting = Input.is_action_pressed("sprint") if InputMap.has_action("sprint") else Input.is_action_pressed("ui_select")
	
	# Get the input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Handle movement and acceleration
	var target_speed = sprint_speed if is_sprinting else speed
	var target_velocity = direction * target_speed
	var current_velocity = Vector3(velocity.x, 0, velocity.z)
	var accel_rate = acceleration if direction else deceleration
	current_velocity = current_velocity.lerp(target_velocity, accel_rate * delta)
	
	velocity.x = current_velocity.x
	velocity.z = current_velocity.z
	
	# Handle shield regeneration
	process_shield_regen(delta)
	
	# Move the character
	move_and_slide()
	
	# Update animations
	update_animation_parameters()

# Function to update animation parameters in the AnimationTree
func update_animation_parameters():
	# First, check floor state changes for landing animation
	if is_on_floor() and !was_on_floor and current_state != "Land":
		animation_state.travel("Land")
		current_state = "Land"
	
	was_on_floor = is_on_floor()
	
	# Handle jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		animation_state.travel("Jump")
		current_state = "Jump"
		return
	
	# Don't interrupt jump/fall/land animations
	if current_state in ["Jump", "Fall", "Land"]:
		# Only switch to fall if we're in Jump and starting to descend
		if current_state == "Jump" and velocity.y < -0.5:
			animation_state.travel("Fall")
			current_state = "Fall"
		return
	
	# Get horizontal velocity for movement animations
	var horizontal_velocity = Vector2(velocity.x, velocity.z).length()
	
	# Choose animation based on speed
	if horizontal_velocity < 0.1:
		if current_state != "Idle":
			animation_state.travel("Idle")
			current_state = "Idle"
	elif is_sprinting and horizontal_velocity > 0.1:
		if current_state != "Run":
			animation_state.travel("Run")
			current_state = "Run"
	else:  # Walking speed
		if current_state != "Walk":
			animation_state.travel("Walk")
			current_state = "Walk"

# Player damage system
func take_damage(amount):
	shield_timer = 0.0
	
	if shield > 0:
		if shield >= amount:
			shield -= amount
			amount = 0
		else:
			amount -= shield
			shield = 0
	
	if amount > 0:
		health -= amount
		
		if health <= 0:
			health = 0
			die()
			
	# Play hit animation if we have one available
	if animation_player.has_animation("Hit_Chest") and current_state not in ["Jump", "Fall"]:
		animation_state.travel("Hit")
		# Don't update current_state so we can return to previous state after hit animation

# Shield regeneration
func process_shield_regen(delta):
	shield_timer += delta
	
	if shield_timer >= shield_regen_delay and shield < max_shield:
		shield += shield_regen_rate * delta
		shield = min(shield, max_shield)

# Health restoration
func heal(amount):
	health += amount
	health = min(health, max_health)

# Death and respawn
func die():
	# Play death animation if available
	if animation_player.has_animation("Death01"):
		animation_state.travel("Death")
		current_state = "Death"
	
	# In a full game, you might want to add respawn logic here
	# For now, just reset health and shield
	health = max_health
	shield = max_shield

# Resource collection
func collect_resource(resource_name: String, amount: int):
	if inventory.has(resource_name):
		inventory[resource_name] += amount
	else:
		inventory[resource_name] = amount
	
	# You could add a collection animation here
	if animation_player.has_animation("Interact"):
		animation_state.travel("Interact")
		# Don't update current_state so we can return to previous state after interact animation

# Weapon handling functions (for when you implement weapons)
func weapon_fired(weapon):
	# Play shoot animation based on weapon type
	if weapon.type == "kinetic" and animation_player.has_animation("Pistol_Shoot"):
		animation_state.travel("Shoot")
	elif weapon.type == "energy" and animation_player.has_animation("Spell_Simple_Shoot"):
		animation_state.travel("Shoot")
	# Add more weapon types and animations as needed

func weapon_switched(weapon):
	# Update weapon model visibility
	# This would be implemented when you add weapon models to the character
	pass
