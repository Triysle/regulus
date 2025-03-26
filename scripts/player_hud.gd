extends Control

@onready var shield_bar = $MarginContainer/VBoxContainer/ShieldBar
@onready var armor_bar = $MarginContainer/VBoxContainer/ArmorBar
@onready var health_bar = $MarginContainer/VBoxContainer/HealthBar

# Colors for the different bars
var shield_color = Color(0.0, 0.5, 1.0)  # Blue
var armor_color = Color(0.7, 0.7, 0.7)   # Gray
var health_color = Color(0.8, 0.2, 0.2)  # Red

func _ready():
	# Set the colors of the progress bars
	shield_bar.modulate = shield_color
	armor_bar.modulate = armor_color
	health_bar.modulate = health_color

func update_display(shield, max_shield, armor, max_armor, health, max_health):
	# Update values and max values
	shield_bar.max_value = max_shield
	shield_bar.value = shield
	
	armor_bar.max_value = max_armor
	armor_bar.value = armor
	
	health_bar.max_value = max_health
	health_bar.value = health
