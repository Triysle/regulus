extends CharacterBody3D

# Movement variables
@export var speed = 5.0
@export var jump_velocity = 4.5
@export var mouse_sensitivity = 0.002
@export var acceleration = 10.0
@export var deceleration = 20.0

# Defensive system variables
@export var max_shield = 100.0
@export var max_armor = 100.0
@export var max_health = 100.0
@export var shield_regen_rate = 5.0  # Per second
@export var shield_regen_delay = 3.0  # Seconds after damage
@export var health_regen_rate = 1.0  # Per second

var shield = max_shield
var armor = max_armor
var health = max_health
var shield_timer = 0.0

# Equipment variables
var current_weapon = null
var equipment = {}

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Camera reference
@onready var camera = $Camera3D
@onready var interaction_ray = $Camera3D/RayCast3D

func _ready():
	# Capture mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
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

# Process damage with the three-tier defense system
func take_damage(amount, damage_type = "kinetic"):
	# Reset shield regeneration timer
	shield_timer = 0.0
	
	var remaining_damage = amount
	
	# Apply damage type modifiers
	# This would be expanded based on your specific damage types
	var shield_modifier = 1.0
	var armor_modifier = 1.0
	var health_modifier = 1.0
	
	match damage_type:
		"kinetic":
			shield_modifier = 0.8
			armor_modifier = 1.0
			health_modifier = 1.2
		"energy":
			shield_modifier = 1.5
			armor_modifier = 0.8
			health_modifier = 0.9
		"explosive":
			shield_modifier = 1.0
			armor_modifier = 1.5
			health_modifier = 1.0
	
	# First apply to shield
	if shield > 0:
		var shield_damage = remaining_damage * shield_modifier
		if shield >= shield_damage:
			shield -= shield_damage
			remaining_damage = 0
		else:
			remaining_damage -= shield / shield_modifier
			shield = 0
	
	# Then apply to armor
	if remaining_damage > 0 and armor > 0:
		var armor_damage = remaining_damage * armor_modifier
		if armor >= armor_damage:
			armor -= armor_damage
			remaining_damage = 0
		else:
			remaining_damage -= armor / armor_modifier
			armor = 0
	
	# Finally apply to health
	if remaining_damage > 0:
		health -= remaining_damage * health_modifier
		
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
	
	# Very small health regeneration
	if health < max_health:
		health += health_regen_rate * delta
		health = min(health, max_health)

func repair_armor(amount):
	armor += amount
	armor = min(armor, max_armor)

func heal(amount):
	health += amount
	health = min(health, max_health)

func die():
	print("Player died")
	# Game over logic would go here
	# For now, just reset health for demonstration
	health = max_health
	armor = max_armor
	shield = max_shield
