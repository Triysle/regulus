extends Node3D

signal weapon_fired(weapon_data)
signal weapon_switched(weapon_data)

@export var weapons: Array[WeaponData] = []
@export var current_weapon_index: int = 0

@onready var cooldown_timer = $CooldownTimer
@onready var reload_timer = $ReloadTimer
@onready var raycast = $RayCast3D
@onready var animation_player = $AnimationPlayer
@onready var weapon_model = $WeaponModel
@onready var weapon_models = {
	"Kinetic Rifle": $WeaponModel/KineticRifle,
	"Energy Blaster": $WeaponModel/EnergyBlaster,
	"Explosive Launcher": $WeaponModel/ExplosiveLauncher
}

var current_ammo = {}
var is_reloading = false

func _ready():
	for weapon in weapons:
		current_ammo[weapon.name] = weapon.ammo_capacity
	
	cooldown_timer.one_shot = true
	reload_timer.one_shot = true
	
	# Hide all weapons initially
	for model in weapon_models.values():
		model.visible = false
	
	if weapons.size() > 0:
		switch_to_weapon(0)
	
	reload_timer.connect("timeout", _on_reload_timer_timeout)

func _process(delta):
	if Input.is_action_just_pressed("weapon_next"):
		cycle_weapon(1)
	elif Input.is_action_just_pressed("weapon_prev"):
		cycle_weapon(-1)
	
	if Input.is_action_just_pressed("reload"):
		start_reload()
	
	if weapons.size() > 0:
		var current_weapon = weapons[current_weapon_index]
		
		if current_weapon.automatic:
			if Input.is_action_pressed("fire") and can_fire():
				fire()
		else:
			if Input.is_action_just_pressed("fire") and can_fire():
				fire()

func can_fire():
	if weapons.size() == 0:
		return false
	
	var current_weapon = weapons[current_weapon_index]
	
	if cooldown_timer.time_left > 0 or is_reloading:
		return false
	
	if current_ammo[current_weapon.name] <= 0:
		start_reload()
		return false
	
	return true

func fire():
	var current_weapon = weapons[current_weapon_index]
	
	current_ammo[current_weapon.name] -= 1
	
	cooldown_timer.wait_time = current_weapon.fire_rate
	cooldown_timer.start()
	
	if animation_player and animation_player.has_animation("fire"):
		animation_player.play("fire")
	
	# if muzzle_flash:
	# 	muzzle_flash.emitting = true
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		
		if collider is CollisionShape3D:
			collider = collider.get_parent()
		
		if collider is Area3D:
			collider = collider.get_parent()
		
		if collider.has_method("take_damage"):
			collider.take_damage(current_weapon.damage)
	
	emit_signal("weapon_fired", current_weapon)

func start_reload():
	if weapons.size() == 0:
		return
		
	var current_weapon = weapons[current_weapon_index]
	
	if current_ammo[current_weapon.name] == current_weapon.ammo_capacity:
		return
	
	is_reloading = true
	reload_timer.wait_time = current_weapon.reload_time
	reload_timer.start()
	
	if animation_player and animation_player.has_animation("reload"):
		animation_player.play("reload")

func _on_reload_timer_timeout():
	if weapons.size() == 0:
		return
		
	var current_weapon = weapons[current_weapon_index]
	current_ammo[current_weapon.name] = current_weapon.ammo_capacity
	is_reloading = false

func cycle_weapon(direction):
	if weapons.size() == 0:
		return
	
	var new_index = (current_weapon_index + direction) % weapons.size()
	if new_index < 0:
		new_index = weapons.size() - 1
	
	switch_to_weapon(new_index)

func switch_to_weapon(index):
	if index < 0 or index >= weapons.size():
		return
	
	if is_reloading:
		is_reloading = false
		reload_timer.stop()
	
	current_weapon_index = index
	
	update_weapon_display()
	
	emit_signal("weapon_switched", weapons[current_weapon_index])

func update_weapon_display():
	var current_weapon = weapons[current_weapon_index]
	
	# Hide all weapons
	for model in weapon_models.values():
		model.visible = false
	
	# Show current weapon
	if weapon_models.has(current_weapon.name):
		weapon_models[current_weapon.name].visible = true
	
	raycast.target_position = Vector3(0, 0, -current_weapon.range)
