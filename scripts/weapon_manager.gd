extends Node3D

@export var weapons: Array[WeaponData] = []
@export var current_weapon_index: int = 0

@onready var cooldown_timer = $CooldownTimer
@onready var reload_timer = $ReloadTimer
@onready var raycast = $RayCast3D
@onready var animation_player = $AnimationPlayer
@onready var weapon_model = $WeaponModel
@onready var muzzle_flash = $MuzzleFlash

var current_ammo = {}
var is_reloading = false

func _ready():
	# Initialize current ammo for each weapon
	for weapon in weapons:
		current_ammo[weapon.name] = weapon.ammo_capacity
	
	cooldown_timer.one_shot = true
	reload_timer.one_shot = true
	
	# Set initial weapon
	if weapons.size() > 0:
		switch_to_weapon(0)
	
	# Connect signals
	reload_timer.connect("timeout", _on_reload_timer_timeout)

func _process(delta):
	# Input handling
	if Input.is_action_just_pressed("weapon_next"):
		cycle_weapon(1)
	elif Input.is_action_just_pressed("weapon_prev"):
		cycle_weapon(-1)
	
	if Input.is_action_just_pressed("reload"):
		start_reload()
	
	# Weapon firing
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
	
	# Check if we're cooling down or reloading
	if cooldown_timer.time_left > 0 or is_reloading:
		return false
	
	# Check if we have ammo
	if current_ammo[current_weapon.name] <= 0:
		start_reload()
		return false
	
	return true

func fire():
	var current_weapon = weapons[current_weapon_index]
	
	# Consume ammo
	current_ammo[current_weapon.name] -= 1
	
	# Start cooldown
	cooldown_timer.wait_time = current_weapon.fire_rate
	cooldown_timer.start()
	
	# Visual effects
	if animation_player and animation_player.has_animation("fire"):
		animation_player.play("fire")
	
	if muzzle_flash:
		muzzle_flash.emitting = true
	
	# Damage logic
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		
		# If the collider is a collision shape, get its parent
		if collider is CollisionShape3D:
			collider = collider.get_parent()
		
		# If the collider is an Area3D, get its parent
		if collider is Area3D:
			collider = collider.get_parent()
		
		# Apply damage if the object has the take_damage method
		if collider.has_method("take_damage"):
			collider.take_damage(current_weapon.damage)
	
	# Notify the parent (player) that we fired
	get_parent().weapon_fired(current_weapon)

func start_reload():
	var current_weapon = weapons[current_weapon_index]
	
	# Don't reload if ammo is full
	if current_ammo[current_weapon.name] == current_weapon.ammo_capacity:
		return
	
	is_reloading = true
	reload_timer.wait_time = current_weapon.reload_time
	reload_timer.start()
	
	# Play reload animation
	if animation_player and animation_player.has_animation("reload"):
		animation_player.play("reload")

func _on_reload_timer_timeout():
	var current_weapon = weapons[current_weapon_index]
	current_ammo[current_weapon.name] = current_weapon.ammo_capacity
	is_reloading = false

func cycle_weapon(direction):
	var new_index = (current_weapon_index + direction) % weapons.size()
	if new_index < 0:
		new_index = weapons.size() - 1
	
	switch_to_weapon(new_index)

func switch_to_weapon(index):
	if index < 0 or index >= weapons.size():
		return
	
	# Cancel reload if in progress
	if is_reloading:
		is_reloading = false
		reload_timer.stop()
	
	current_weapon_index = index
	
	# Update weapon model and properties
	update_weapon_display()
	
	# Notify the parent (player) that we switched weapons
	get_parent().weapon_switched(weapons[current_weapon_index])

func update_weapon_display():
	var current_weapon = weapons[current_weapon_index]
	
	# Here you would update the weapon model mesh
	# For now we'll just print the current weapon
	print("Switched to: " + current_weapon.name)
	
	# Update raycast range
	raycast.target_position = Vector3(0, 0, -current_weapon.range)
