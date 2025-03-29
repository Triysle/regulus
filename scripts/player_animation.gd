extends Node
class_name PlayerAnimation

# References to animation nodes
var animation_tree: AnimationTree
var lower_state_machine: AnimationNodeStateMachinePlayback
var aim_blend_position: Vector2 = Vector2(0, 0)

# State tracking
var was_in_air: bool = false

func _ready():
	# Get references to animation nodes
	animation_tree = get_parent().get_node("AnimationTree")
	if animation_tree:
		lower_state_machine = animation_tree.get("parameters/LowerStateMachine/playback")

func initialize(anim_tree: AnimationTree):
	animation_tree = anim_tree
	
	if animation_tree:
		print("AnimationTree found, initializing parameters...")
		
		# Check if the required parameters exist
		var parameters = ["parameters/LowerStateMachine/playback", 
						  "parameters/MasterBlend/blend_amount",
						  "parameters/LowerBody/blend_amount",
						  "parameters/UpperBody/blend_position"]
						  
		for param in parameters:
			if animation_tree.get(param) == null:
				print("ERROR: Parameter not found in AnimationTree: " + param)
		
		# Get the state machine
		lower_state_machine = animation_tree.get("parameters/LowerStateMachine/playback")
		if lower_state_machine == null:
			print("ERROR: Could not get LowerStateMachine playback")
		
		# Set initial blend values
		animation_tree.set("parameters/MasterBlend/blend_amount", 1.0)  # Full blend
		animation_tree.set("parameters/LowerBody/blend_amount", 1.0)    # Full lower body animation
		animation_tree.set("parameters/UpperBody/blend_position", Vector2(0, 0))  # Neutral aim position
		print("Successfully set initial animation parameters")

func update_animation(player_state: Dictionary, delta: float):
	# Skip animation updates if animation tree isn't ready
	if !animation_tree:
		return
		
	# Update upper body aim blend position
	animation_tree.set("parameters/UpperBody/blend_position", aim_blend_position)
	
	# Handle lower body animations through state machine
	if lower_state_machine:
		var current_state = lower_state_machine.get_current_node()
		var target_state = "idle"
		
		# Determine the appropriate animation state based on player state
		if !player_state.is_on_floor:
			# Handle jumping/falling animations
			if current_state == "jump_start":
				# Let jump_start animation finish
				return
			elif current_state == "jump_land":
				# Let landing animation finish
				return
			elif player_state.velocity.y > 0:
				target_state = "jump"
			else:
				target_state = "jump" # Use jump animation for falling too
		elif player_state.is_crouching:
			# Crouching states
			if abs(player_state.velocity.x) > 0.1 or abs(player_state.velocity.z) > 0.1:
				target_state = "crouch_walk"
			else:
				target_state = "crouch_idle"
		else:
			# Standing states
			if player_state.is_sprinting:
				target_state = "sprint"
			elif player_state.is_walking:
				target_state = "walk"
			elif abs(player_state.velocity.x) > 0.1 or abs(player_state.velocity.z) > 0.1:
				target_state = "jog"
			else:
				target_state = "idle"
		
		# Only change state if we're not already in that state
		if current_state != target_state:
			lower_state_machine.travel(target_state)

func start_jump_animation():
	if lower_state_machine:
		lower_state_machine.travel("jump_start")

func on_landed(is_on_floor: bool):
	if lower_state_machine and is_on_floor and was_in_air:
		lower_state_machine.travel("jump_land")
		was_in_air = false

func set_in_air(in_air: bool):
	was_in_air = in_air

func get_current_state() -> String:
	if lower_state_machine:
		return lower_state_machine.get_current_node()
	return ""

func update_aim_direction(pitch: float):
	# Map pitch (-PI/2 to PI/2) to blend position (1 to -1)
	# Where up is -1 and down is 1
	var blend_y = clamp(pitch / (PI/2), -1.0, 1.0)
	aim_blend_position = Vector2(0, blend_y)
