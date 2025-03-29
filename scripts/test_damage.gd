extends Node3D

@export var damage_amount: float = 10.0

func interact(player):
	# Apply damage to the player
	player.take_damage(damage_amount)
	print("Applied " + str(damage_amount) + " damage")

# Return custom interaction text for this damage object
func get_interaction_text() -> String:
	return "test damage (" + str(damage_amount) + ")"
