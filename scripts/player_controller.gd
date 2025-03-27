extends CharacterBody3D

@export var speed = 5.0
@export var jump_velocity = 4.5
@export var mouse_sensitivity = 0.002
@export var acceleration = 10.0
@export var deceleration = 20.0

@export var max_shield = 100.0
@export var max_health = 100.0
@export var shield_regen_rate = 5.0
@export var shield_regen_delay = 3.0

var shield = max_shield
var health = max_health
var shield_timer = 0.0

var inventory = {
	"Unobtanium": 0
}

@onready var camera = $Camera3D
@onready var interaction_ray = $Camera3D/RayCast3D
@onready var hud = $CanvasLayer/PlayerHud
@onready var weapon_manager = $Camera3D/WeaponManager

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")
	update_hud()
	
	if weapon_manager:
		weapon_manager.connect("weapon_fired", Callable(self, "weapon_fired"))
		weapon_manager.connect("weapon_switched", Callable(self, "weapon_switched"))

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event.is_action_pressed("interact") and interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()
		
		if collider is CollisionShape3D:
			collider = collider.get_parent()
		
		if collider is Area3D:
			collider = collider.get_parent()
			
		if collider.has_method("interact"):
			collider.interact(self)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var target_velocity = direction * speed
	
	var current_velocity = Vector3(velocity.x, 0, velocity.z)
	var accel_rate = acceleration if direction else deceleration
	current_velocity = current_velocity.lerp(target_velocity, accel_rate * delta)
	
	velocity.x = current_velocity.x
	velocity.z = current_velocity.z
	
	move_and_slide()
	
	process_shield_regen(delta)
	
	update_hud()

func take_damage(amount):
	shield_timer = 0.0
	
	if shield > 0:
		if shield >= amount:
			shield -= amount
			amount = 0
		else:
			amount -= shield
			shield = 0
	
	if amount > 0:
		health -= amount
		
		if health <= 0:
			health = 0
			die()

func process_shield_regen(delta):
	shield_timer += delta
	
	if shield_timer >= shield_regen_delay and shield < max_shield:
		shield += shield_regen_rate * delta
		shield = min(shield, max_shield)

func heal(amount):
	health += amount
	health = min(health, max_health)

func die():
	health = max_health
	shield = max_shield

func update_hud():
	if hud:
		hud.update_display(shield, max_shield, health, max_health)
		update_resource_display()

func collect_resource(resource_name: String, amount: int):
	if inventory.has(resource_name):
		inventory[resource_name] += amount
	else:
		inventory[resource_name] = amount
	
	update_resource_display()

func update_resource_display():
	if hud:
		hud.update_resources(inventory)

func weapon_fired(weapon):
	print("Fired " + weapon.name)

func weapon_switched(weapon):
	print("Switched to " + weapon.name)
