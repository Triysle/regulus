extends Node
class_name PlayerStats

signal health_changed(current, maximum)
signal shield_changed(current, maximum)
signal stamina_changed(current, maximum)
signal player_died

# Health and shield parameters
@export var max_health: float = 100.0
@export var max_shield: float = 100.0
@export var shield_regen_rate: float = 5.0  # Shield points per second
@export var shield_regen_delay: float = 3.0  # Seconds after damage before regen starts

# Stamina parameters
@export var max_stamina: float = 100.0
@export var stamina_regen_rate: float = 10.0  # Per second
@export var stamina_drain_rate: float = 15.0  # Per second
@export var stamina_recovery_delay: float = 1.5  # After fully depleted

# Current states
var health: float
var shield: float
var stamina: float

var last_damage_time: float = 0.0
var stamina_depleted_time: float = 0.0
var can_sprint: bool = true

func _ready():
	# Initialize to max values
	health = max_health
	shield = max_shield
	stamina = max_stamina
	
	# Emit initial values after a short delay to ensure connections are established
	call_deferred("_emit_initial_signals")

func _emit_initial_signals():
	emit_signal("health_changed", health, max_health)
	emit_signal("shield_changed", shield, max_shield)
	emit_signal("stamina_changed", stamina, max_stamina)

func _process(delta):
	# Shield regeneration
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_damage_time > shield_regen_delay:
		set_shield(min(shield + shield_regen_rate * delta, max_shield))
	
	# Stamina regeneration when not sprinting or after recovery delay
	if can_sprint:
		if current_time - stamina_depleted_time > stamina_recovery_delay or stamina > 0:
			set_stamina(min(stamina + stamina_regen_rate * delta, max_stamina))

func take_damage(amount: float):
	# Record time of damage for shield regeneration delay
	last_damage_time = Time.get_ticks_msec() / 1000.0
	
	# Damage is applied to shield first, then health
	if shield > 0:
		if shield >= amount:
			set_shield(shield - amount)
			amount = 0
		else:
			amount -= shield
			set_shield(0)
	
	if amount > 0:
		set_health(health - amount)
	
	# Check for death
	if health <= 0:
		emit_signal("player_died")

func use_stamina(delta: float) -> bool:
	if stamina <= 0:
		if can_sprint:
			stamina_depleted_time = Time.get_ticks_msec() / 1000.0
			can_sprint = false
		return false
	
	set_stamina(max(0, stamina - stamina_drain_rate * delta))
	return true

func can_use_stamina() -> bool:
	if stamina > 0:
		return true
	
	# Check if we've recovered from depletion
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - stamina_depleted_time > stamina_recovery_delay:
		can_sprint = true
		return stamina > 0
	
	return false

func set_health(value: float):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health, max_health)

func set_shield(value: float):
	shield = clamp(value, 0, max_shield)
	emit_signal("shield_changed", shield, max_shield)

func set_stamina(value: float):
	stamina = clamp(value, 0, max_stamina)
	emit_signal("stamina_changed", stamina, max_stamina)

func reset():
	health = max_health
	shield = max_shield
	stamina = max_stamina
	can_sprint = true
	
	emit_signal("health_changed", health, max_health)
	emit_signal("shield_changed", shield, max_shield)
	emit_signal("stamina_changed", stamina, max_stamina)
