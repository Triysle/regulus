extends CharacterBody3D

# Movement parameters
@export var speed = 5.0
@export var jump_velocity = 4.5
@export var mouse_sensitivity = 0.002
@export var acceleration = 10.0
@export var deceleration = 20.0

# Player stats (preserved from original controller)
@export var max_shield = 100.0
@export var max_health = 100.0
@export var shield_regen_rate = 5.0
@export var shield_regen_delay = 3.0

var shield = max_shield
var health = max_health
var shield_timer = 0.0

# Inventory (preserved from original controller)
var inventory = {
	"Unobtanium": 0
}

# Node references (we'll connect these in _ready)
@onready var camera = $Camera3D
@onready var animation_tree = $AnimationPlayer/AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var skeleton = $Rig/Skeleton3D

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

func toggle_mouse_capture():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	
	# Get the input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Handle movement and acceleration
	var target_velocity = direction * speed
	var current_velocity = Vector3(velocity.x, 0, velocity.z)
	var accel_rate = acceleration if direction else deceleration
	current_velocity = current_velocity.lerp(target_velocity, accel_rate * delta)
	
	velocity.x = current_velocity.x
	velocity.z = current_velocity.z
	
	# Handle shield regeneration
	process_shield_regen(delta)
	
	# Move the character
	move_and_slide()
	
	# Update animations (we'll implement this next)
	update_animation_parameters()

# Function to update animation parameters in the AnimationTree
func update_animation_parameters():
	# We'll implement this in the next step
	pass

# Preserved from original controller
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

# Preserved from original controller
func process_shield_regen(delta):
	shield_timer += delta
	
	if shield_timer >= shield_regen_delay and shield < max_shield:
		shield += shield_regen_rate * delta
		shield = min(shield, max_shield)

# Preserved from original controller
func heal(amount):
	health += amount
	health = min(health, max_health)

# Preserved from original controller
func die():
	health = max_health
	shield = max_shield

# Preserved from original controller
func collect_resource(resource_name: String, amount: int):
	if inventory.has(resource_name):
		inventory[resource_name] += amount
	else:
		inventory[resource_name] = amount
