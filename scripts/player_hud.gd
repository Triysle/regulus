extends Control

@onready var shield_bar = $MarginContainer/VBoxContainer/ShieldBar
@onready var health_bar = $MarginContainer/VBoxContainer/HealthBar
@onready var resource_label = $ResourceContainer/ResourceLabel
@onready var interaction_label = $InteractionPrompt

func _ready():
	resource_label.text = "Unobtanium: 0"
	
	# Initialize interaction prompt
	interaction_label.text = ""
	interaction_label.visible = false

func update_display(shield, max_shield, health, max_health):
	shield_bar.max_value = max_shield
	shield_bar.value = shield
	
	health_bar.max_value = max_health
	health_bar.value = health

func update_resources(inventory):
	if inventory.has("Unobtanium"):
		resource_label.text = "Unobtanium: " + str(inventory["Unobtanium"])
	else:
		resource_label.text = "Unobtanium: 0"

# Handle interaction prompts
func show_interaction_prompt(action_text: String):
	interaction_label.text = "Press [E] to " + action_text
	interaction_label.visible = true

func hide_interaction_prompt():
	interaction_label.visible = false
