extends CharacterBody3D

class_name Player

# Mouse sensitivity
@export var mouse_sensitivity: float = 0.003

# Camera mode variables
var third_person_mode: bool = false
@onready var first_person_cam_pos = $Camera3D.position
const THIRD_PERSON_DISTANCE = 3.0

# Component references
@onready var camera = $Camera3D
@onready var collision_shape = $CollisionShape3D
@onready var weapon_manager = $Camera3D/WeaponManager
@onready var hud = $CanvasLayer/PlayerHud

# Components
@onready var stats: PlayerStats = $PlayerStats
@onready var animation_handler: PlayerAnimation = $PlayerAnimation
@onready var movement_handler: PlayerMovement = $PlayerMovement
@onready var interaction_handler: PlayerInteraction = $PlayerInteraction

func _ready():
	# Lock mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Initialize HUD
	hud.update_display(stats.shield, stats.max_shield, stats.health, stats.max_health)
	hud.update_resources(interaction_handler.inventory)
	
	# Connect weapon manager signals
	if weapon_manager:
		weapon_manager.weapon_fired.connect(_on_weapon_fired)
		weapon_manager.weapon_switched.connect(_on_weapon_switched)
	
	# Connect stats signals
	stats.health_changed.connect(_on_health_changed)
	stats.shield_changed.connect(_on_shield_changed)
	stats.player_died.connect(_on_player_died)
	
	# Connect interaction signals
	interaction_handler.resource_collected.connect(_on_resource_collected)
	
	# Connect movement signals
	movement_handler.jump_started.connect(_on_jump_started)
	movement_handler.landed.connect(_on_landed)
	
	# Initialize component references
	movement_handler.initialize(self, camera, collision_shape, stats)
	interaction_handler.initialize(self, camera)
	animation_handler.initialize($AnimationTree)
	
	# Hide the player mesh in first-person mode by default
	if $Rig:
		$Rig.visible = false

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
		interaction_handler.interact()
	
	# Toggle crouch
	if event.is_action_pressed("crouch"):
		movement_handler.toggle_crouch(third_person_mode)
	
	# Toggle walk
	if event.is_action_pressed("walk"):
		movement_handler.toggle_walk()
	
	# Jump
	if event.is_action_just_pressed("jump"):
		movement_handler.jump()
	
	# Toggle camera mode with Backspace
	if event.is_action_pressed("toggle_camera"):
		toggle_camera_mode()

func _physics_process(delta):
	# Get input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	# Process movement
	var state = movement_handler.process_movement(delta, input_dir, third_person_mode)
	
	# Update animation
	animation_handler.update_animation(state, delta)
	
	# Move the character
	move_and_slide()

# Event handlers
func _on_health_changed(current, maximum):
	hud.update_display(stats.shield, stats.max_shield, stats.health, stats.max_health)

func _on_shield_changed(current, maximum):
	hud.update_display(stats.shield, stats.max_shield, stats.health, stats.max_health)

func _on_player_died():
	# Handle player death
	print("Player died!")
	stats.reset()
	global_position = Vector3(0, 2, 0)  # Reset position

func _on_resource_collected(resource_name, amount):
	print("Collected " + str(amount) + " " + resource_name)
	hud.update_resources(interaction_handler.inventory)

func _on_weapon_fired(weapon_data):
	# Handle weapon recoil, sfx, etc.
	print("Fired weapon: " + weapon_data.name)

func _on_weapon_switched(weapon_data):
	# Update HUD or handle weapon switch effects
	print("Switched to weapon: " + weapon_data.name)

func _on_jump_started():
	animation_handler.start_jump_animation()

func _on_landed(is_on_ground):
	animation_handler.on_landed(is_on_ground)

# Public methods that other scripts can call
func take_damage(amount: float):
	stats.take_damage(amount)

func collect_resource(resource_name: String, amount: int):
	return interaction_handler.collect_resource(resource_name, amount)

func get_current_weapon():
	if weapon_manager:
		return weapon_manager.weapons[weapon_manager.current_weapon_index]
	return null

func toggle_camera_mode():
	third_person_mode = !third_person_mode
	
	if third_person_mode:
		# Switch to third-person - higher and slightly closer
		camera.position = Vector3(0, 2.0, 2.5)
		# Make player mesh visible in third-person
		if $Rig:
			$Rig.visible = true
		# Rotate the camera to face forward
		camera.rotation = Vector3(-0.2, 0, 0)  # Tilt down slightly
	else:
		# Switch back to first-person
		camera.position = first_person_cam_pos
		# Hide player mesh in first-person
		if $Rig:
			$Rig.visible = false
	
	# Update the camera controller
	if camera.has_method("set_third_person_mode"):
		camera.set_third_person_mode(third_person_mode)
	
	# Update the camera controller's reference position
	if camera.has_method("update_base_position"):
		camera.update_base_position(camera.position)
