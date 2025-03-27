extends Control

@onready var shield_bar = $MarginContainer/VBoxContainer/ShieldBar
@onready var health_bar = $MarginContainer/VBoxContainer/HealthBar
@onready var resource_label = $ResourceContainer/ResourceLabel

func _ready():
	resource_label.text = "Unobtanium: 0"

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
