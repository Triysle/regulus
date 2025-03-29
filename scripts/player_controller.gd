extends CharacterBody3D

class_name Player

# Mouse sensitivity
@export var mouse_sensitivity: float = 0.003

# Component references
@onready var camera = $Camera3D
@onready var collision_shape = $CollisionShape3D
@onready var weapon_manager = $Camera3D/WeaponManager
@onready var hud = $CanvasLayer/PlayerHud
@onready var stats = $PlayerStats
@onready var movement_handler = $PlayerMovement
@onready var interaction_handler = $PlayerInteraction

func _ready():
	# Lock mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Initialize component references
	movement_handler.initialize(self, camera, collision_shape, stats)
	interaction_handler.initialize(self, camera)
	
	# Initialize HUD
	if hud and stats:
		hud.update_display(stats.shield, stats.max_shield, stats.health, stats.max_health)
		hud.update_resources(interaction_handler.inventory)
	
	# Note: No signal connections here - they're connected in the editor

func _input(event):
	# Handle mouse movement for camera control
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * mouse_sensitivity)
			camera.rotate_x(-event.relative.y * mouse_sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
		return
	
	# Only process input if mouse is captured
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		# Handle escape key to capture mouse
		if Input.is_action_just_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		return
	
	# Toggle mouse capture with escape key
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		return
	
	# Interact with objects
	if Input.is_action_just_pressed("interact"):
		interaction_handler.interact()
	
	# Toggle crouch
	if Input.is_action_just_pressed("crouch"):
		movement_handler.toggle_crouch()
	
	# Toggle walk
	if Input.is_action_just_pressed("walk"):
		movement_handler.toggle_walk()
	
	# Jump
	if Input.is_action_just_pressed("jump"):
		movement_handler.jump()

func _physics_process(delta):
	# Get input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	# Process movement
	movement_handler.process_movement(delta, input_dir)
	
	# Move the character
	move_and_slide()

# Event handlers for stats
func _on_health_changed(_current, _maximum):
	# Add a safety check to prevent accessing properties on null objects
	if stats != null and hud != null:
		hud.update_display(stats.shield, stats.max_shield, stats.health, stats.max_health)

func _on_shield_changed(_current, _maximum):
	# Add a safety check to prevent accessing properties on null objects
	if stats != null and hud != null:
		hud.update_display(stats.shield, stats.max_shield, stats.health, stats.max_health)

func _on_player_died():
	# Handle player death
	print("Player died!")
	stats.reset()
	global_position = Vector3(0, 2, 0)  # Reset position

# Event handlers for interaction
func _on_interaction_detected(_interactable, action_text):
	hud.show_interaction_prompt(action_text)

func _on_interaction_ended():
	hud.hide_interaction_prompt()

func _on_resource_collected(resource_name, amount):
	print("Collected " + str(amount) + " " + resource_name)
	hud.update_resources(interaction_handler.inventory)

# Event handlers for weapons
func _on_weapon_fired(weapon_data):
	# Handle weapon recoil, sfx, etc.
	print("Player controller received weapon fired: " + weapon_data.name)

func _on_weapon_switched(weapon_data):
	# Update HUD or handle weapon switch effects
	print("Switched to weapon: " + weapon_data.name)

# Public methods that other scripts can call
func take_damage(amount: float):
	stats.take_damage(amount)

func collect_resource(resource_name: String, amount: int):
	return interaction_handler.collect_resource(resource_name, amount)

func get_current_weapon():
	return weapon_manager.weapons[weapon_manager.current_weapon_index]
