extends CharacterBody3D

# Movement variables
@export var speed = 5.0
@export var jump_velocity = 4.5
@export var mouse_sensitivity = 0.002
@export var acceleration = 10.0
@export var deceleration = 20.0

# Defense system variables
@export var max_shield = 100.0
@export var max_health = 100.0
@export var shield_regen_rate = 5.0  # Per second
@export var shield_regen_delay = 3.0  # Seconds after damage

var shield = max_shield
var health = max_health
var shield_timer = 0.0

# Node references
@onready var camera = $Camera3D
@onready var interaction_ray = $Camera3D/RayCast3D
@onready var hud = $CanvasLayer/PlayerHud

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	# Capture mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Initialize HUD
	update_hud()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		print("Mouse motion: ", event.relative)
	
	# Mouse look
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	# Toggle mouse capture
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Basic interaction
	if event.is_action_pressed("interact") and interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()
		if collider.has_method("interact"):
			collider.interact(self)

func _physics_process(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	
	# Movement input
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Calculate target velocity based on input
	var target_velocity = direction * speed
	
	# Apply acceleration/deceleration to horizontal velocity
	var current_velocity = Vector3(velocity.x, 0, velocity.z)
	var accel_rate = acceleration if direction else deceleration
	current_velocity = current_velocity.lerp(target_velocity, accel_rate * delta)
	
	# Apply horizontal velocity
	velocity.x = current_velocity.x
	velocity.z = current_velocity.z
	
	# Move the character
	move_and_slide()
	
	# Handle shield regeneration
	process_shield_regen(delta)
	
	# Update HUD
	update_hud()

# Process damage with shield-then-health system
func take_damage(amount):
	# Reset shield regeneration timer
	shield_timer = 0.0
	
	# First apply to shield
	if shield > 0:
		if shield >= amount:
			shield -= amount
			amount = 0
		else:
			amount -= shield
			shield = 0
	
	# Then apply remaining damage to health
	if amount > 0:
		health -= amount
		
		# Check for death
		if health <= 0:
			health = 0
			die()

func process_shield_regen(delta):
	# Increment shield timer
	shield_timer += delta
	
	# If shield regen delay has passed, regenerate shield
	if shield_timer >= shield_regen_delay and shield < max_shield:
		shield += shield_regen_rate * delta
		shield = min(shield, max_shield)

func heal(amount):
	health += amount
	health = min(health, max_health)

func die():
	print("Player died")
	# Game over logic would go here
	# For now, just reset health for demonstration
	health = max_health
	shield = max_shield

func update_hud():
	if hud:
		hud.update_display(shield, max_shield, health, max_health)
