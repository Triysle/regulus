extends CharacterBody3D

# Movement parameters
@export var walk_speed = 5.0
@export var sprint_speed = 8.0
@export var jump_velocity = 4.5
@export var mouse_sensitivity = 0.002
@export var acceleration = 10.0
@export var deceleration = 20.0

# Camera parameters
@export var first_person_position = Vector3(0, 1.7, -0.4)
@export var third_person_position = Vector3(0, 2.0, 3.0)
@export var camera_transition_speed = 10.0
var is_first_person = true

# Node references
@onready var camera = $Camera3D
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationPlayer/AnimationTree
@onready var animation_state = animation_tree["parameters/playback"] if animation_tree else null

# State tracking
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_speed = walk_speed
var is_sprinting = false
var was_on_floor = true
var camera_toggle_cooldown = false
var jumping = false
var landing = false

func _ready():
	# Capture mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Initialize animation tree if it exists
	if animation_tree:
		animation_tree.active = true
		animation_state = animation_tree["parameters/playback"]
	
	# Set initial camera position
	camera.position = first_person_position

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
	
	# Toggle camera perspective with Backspace
	if event is InputEventKey and event.keycode == KEY_BACKSPACE and event.pressed and not event.is_echo():
		if not camera_toggle_cooldown:
			toggle_camera_perspective()
			# Set cooldown flag
			camera_toggle_cooldown = true
			# Create a timer to reset the cooldown
			var timer = get_tree().create_timer(0.5)
			timer.timeout.connect(func(): camera_toggle_cooldown = false)

func toggle_camera_perspective():
	is_first_person = !is_first_person
	print("Toggling camera to: ", "First Person" if is_first_person else "Third Person")
	
	# We'll use a tween for smooth transition between perspectives
	var tween = create_tween()
	tween.tween_property(camera, "position", 
						first_person_position if is_first_person else third_person_position, 
						0.3)
	
	# Optionally you can also adjust the near clip plane for better visibility in each mode
	if is_first_person:
		camera.near = 0.05
	else:
		camera.near = 0.01

func _physics_process(delta):
	# Check floor state for landing animation
	var just_landed = not was_on_floor and is_on_floor()
	if just_landed:
		landing = true
		jumping = false
	
	was_on_floor = is_on_floor()
	
	# Add gravity when in air
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not jumping and not landing:
		velocity.y = jump_velocity
		jumping = true
		# Start jump animation sequence
		if animation_state:
			animation_state.travel("Jump_Start")
	
	# Handle sprint toggle
	is_sprinting = Input.is_action_pressed("sprint") if InputMap.has_action("sprint") else Input.is_action_pressed("ui_select")
	current_speed = sprint_speed if is_sprinting else walk_speed
	
	# Get input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	# Calculate movement direction relative to camera orientation
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Apply acceleration/deceleration
	if direction:
		var target_velocity = direction * current_speed
		velocity.x = move_toward(velocity.x, target_velocity.x, acceleration * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		velocity.z = move_toward(velocity.z, 0, deceleration * delta)
	
	move_and_slide()
	
	# Update animations based on movement
	update_animations(direction.length())

func update_animations(speed):
	if not animation_state:
		return
	
	var current_anim = animation_state.get_current_node()
	
	# Handle jump states transitions
	if jumping:
		if is_on_floor():
			jumping = false
			landing = true
			animation_state.travel("Jump_Land")
		elif current_anim == "Jump_Start" and animation_player.get_current_animation_position() >= animation_player.get_current_animation_length() - 0.1:
			# Transition to mid-air state near the end of jump start animation
			animation_state.travel("Jump")
		return
	
	# Handle landing state
	if landing:
		if current_anim == "Jump_Land" and animation_player.get_current_animation_position() >= animation_player.get_current_animation_length() - 0.1:
			# Near the end of landing animation
			landing = false
			
			# Transition to appropriate ground movement
			if speed > 0.1:
				animation_state.travel("Walk")
			else:
				animation_state.travel("Idle")
		return
	
	# Don't interrupt these animations
	if current_anim in ["Jump_Start", "Jump", "Jump_Land"]:
		return
	
	# Handle ground movement when not jumping or landing
	if is_on_floor():
		if speed > 0.1:
			animation_state.travel("Walk")
		else:
			animation_state.travel("Idle")
