extends CharacterBody3D

# Movement parameters
@export var walk_speed = 3.0
@export var run_speed = 5.0
@export var acceleration = 10.0
@export var deceleration = 20.0
@export var mouse_sensitivity = 0.002
@export var gravity_multiplier = 1.8

# Node references
@onready var camera = $Camera3D
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationPlayer/AnimationTree
@onready var animation_state = null  # Will be set in _ready()

# State tracking
var is_moving = false
var move_direction = Vector3.ZERO
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_multiplier

func _ready():
	# Capture mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Initialize animation tree if it exists
	if animation_tree:
		animation_tree.active = true
		animation_state = animation_tree["parameters/playback"]
		animation_state.travel("Idle")

func _input(event):
	# Mouse look
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	# Toggle mouse capture with Escape key
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	
	# Get movement input
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	# Convert input to 3D movement direction relative to player's facing
	move_direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	var direction = (transform.basis * move_direction)
	
	# Determine if we're moving
	is_moving = direction.length() > 0.1
	
	# Handle horizontal movement with acceleration/deceleration
	var target_velocity = direction * walk_speed
	var current_velocity = Vector3(velocity.x, 0, velocity.z)
	
	if is_moving:
		current_velocity = current_velocity.lerp(target_velocity, acceleration * delta)
	else:
		current_velocity = current_velocity.lerp(Vector3.ZERO, deceleration * delta)
	
	velocity.x = current_velocity.x
	velocity.z = current_velocity.z
	
	# Apply movement
	move_and_slide()
	
	# Update animations
	update_animations()

func update_animations():
	if not animation_state:
		return
		
	if not is_on_floor():
		animation_state.travel("Jump")  # Use Jump as a fallback for in-air state
	elif is_moving:
		animation_state.travel("Walk")
	else:
		animation_state.travel("Idle")
