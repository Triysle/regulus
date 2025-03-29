class_name WeaponData
extends Resource

@export var name: String = "Default Weapon"
@export var damage: float = 10.0
@export var fire_rate: float = 0.5  # seconds between shots
@export var attack_range: float = 100.0  # renamed from "range" to avoid conflict with built-in
@export var ammo_capacity: int = 30
@export var reload_time: float = 1.5
@export var type: String = "kinetic"  # kinetic, energy, explosive
@export var projectile_speed: float = 20.0
@export var automatic: bool = false  # if true, can hold to fire
