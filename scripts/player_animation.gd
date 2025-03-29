extends Node
class_name PlayerAnimation

# References to animation nodes
var animation_tree: AnimationTree
var state_machine: AnimationNodeStateMachinePlayback

# State tracking
var was_in_air: bool = false

func _ready():
	# Get references to animation nodes
	animation_tree = get_parent().get_node("AnimationTree")
	if animation_tree:
		state_machine = animation_tree.get("parameters/playback")

func initialize(anim_tree: AnimationTree):
	animation_tree = anim_tree
	if animation_tree:
		state_machine = animation_tree.get("parameters/playback")

func update_animation(player_state: Dictionary, delta: float):
	# Skip animation updates if animation tree isn't ready
	if !state_machine:
		return
	
	var current_state = state_machine.get_current_node()
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
		state_machine.travel(target_state)

func start_jump_animation():
	if state_machine:
		state_machine.travel("jump_start")

func on_landed(is_on_floor: bool):
	if state_machine and is_on_floor and was_in_air:
		state_machine.travel("jump_land")
		was_in_air = false

func set_in_air(in_air: bool):
	was_in_air = in_air

func get_current_state() -> String:
	if state_machine:
		return state_machine.get_current_node()
	return ""
