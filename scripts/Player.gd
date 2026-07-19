extends CharacterBody2D
class_name Player

@export_group("Movement Parameters")
@export var speed : float = 325 # Pixels per second
@export var accel : float = 80 # Pixels per second per second
@export_subgroup("Jump Parameters")
# Used to calculate the actual physical parameters for the jump
@export var jump_height : float = 128 # In pixels
@export var time_to_peak_seconds : float = 0.4 # In seconds, obviously
@export var time_to_ground_seconds : float = 0.28 # Derives the general gravity
@export var variable_jump_height := true
@export var max_coyote_time : float = 0.05
@export var max_jump_buffer : float = 0.05

#@export_group("Item Stack Options")
#@export var base_knock_off_threshold : float = 650.0

var jump_force : float
var gravity : float # Gravity used while the player is falling
var jump_gravity : float # The gravity used while the player is jumping up

var coyote_timer := 0.0
var jump_buffer_timer := 0.0
var was_on_floor := false # Was the player on the floor last frame?
var is_jumping := false

var extern_impulse := Vector2.ZERO

var last_velocity := Vector2.ZERO
var facing_direction := Vector2.RIGHT

@onready var item_stack : ItemStack = $ItemStack
@onready var interaction_area: Area2D = $InteractionArea

func _ready() -> void:
	add_to_group("player")
	# Calculate jump values
	# I stole these calculations from a GDC talk
	jump_force = 2.0 * jump_height / (time_to_peak_seconds)
	jump_gravity = jump_force / (time_to_peak_seconds * 60)
	# Have to calculate this one from scratch
	gravity = 2.0 * jump_height / (time_to_ground_seconds * time_to_ground_seconds * 60)
	
	# Multiply acceleration values by fps, will be cancelled out by multiplying by delta
	accel *= 60
	gravity *= 60
	jump_gravity *= 60
	
	item_stack.set_player_max_speed(speed)
	item_stack.set_player_gravity(gravity)
	


func _physics_process(delta: float) -> void:	
	horizontal_movement(delta)
	jump(delta)
	
	handle_impulse()
	
	apply_velocity(delta)
	
	item_stack.set_player_velocity(velocity)

# Gets the target horizontal movement velocity from the player's input
func horizontal_movement(delta: float):
	var vel := 0.0
	if Input.is_action_pressed("left"):
		vel -= speed
	if Input.is_action_pressed("right"):
		vel += speed
	
	if vel < 0:
		facing_direction = Vector2.LEFT
	elif vel > 0:
		facing_direction = Vector2.RIGHT
		
	velocity.x = move_toward(velocity.x, vel, accel * delta)
	
	
func jump(delta: float):
	var on_floor = is_on_floor()
	var should_jump = false
	if Input.is_action_just_pressed("jump"):
		if on_floor or coyote_timer > 0:
			should_jump = true
		else:
			# Input buffer
			jump_buffer_timer = max_jump_buffer
	elif jump_buffer_timer > 0 and on_floor:
		should_jump = true
	
	if should_jump:
		is_jumping = true
		velocity.y = -jump_force
	
	# Some kind of primitive variable jump height
	if Input.is_action_just_released("jump") and variable_jump_height:
		is_jumping = false
	
	# Apply gravity
	if on_floor:
		# No need for gravity in this case
		return
	
	if is_jumping:
		velocity.y += jump_gravity * delta
	else:
		velocity.y += gravity * delta
		

func handle_impulse():
	if extern_impulse == Vector2.ZERO:
		return
	is_jumping = false
	velocity = extern_impulse
	extern_impulse = Vector2.ZERO
	print(velocity)

func apply_velocity(delta : float):
	coyote_timer = max(coyote_timer - delta, 0)
	jump_buffer_timer = max(jump_buffer_timer - delta, 0)
	
	if not is_on_floor() and was_on_floor and velocity.y >= 0:
			coyote_timer = max_coyote_time
	
	was_on_floor = is_on_floor()
	#var pre_slide_velocity = velocity
	move_and_slide()

func handle_interaction():
	var areas = interaction_area.get_overlapping_areas() as Array[Node2D]
	var closest : Node2D = null
	var min_distance := 99999.0
	
	# Find closest interactable object
	for area in areas:
		if not area is Interactable:
			continue
		var dist : float = global_position.distance_to(area.global_position)
		if dist < min_distance:
			min_distance = dist
			closest = area
	
	if closest:
		closest.interact(self)
	
func add_item(item : Item):
	item_stack.push_item(item)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("drop"):
		item_stack.drop_voluntarily(facing_direction)
	elif event.is_action_pressed("interact"):
		handle_interaction()
	
func _input(event: InputEvent):
	if (event.is_action_pressed("down") and is_on_floor()):
		position.y += 1

func apply_impulse(direction : Vector2, force : float) -> void:
	# The acceleration will slow us way down in the x direction
	# So some adjustment must be made?
	# Uh... I'll just multiply the x value by some multiple of the acceleration rate?
	# That seems like it'd work better than nothing, and I'd rather not totally
	# 		rework the player movement logic to allow for large horizontal impulses.
	extern_impulse.x = direction.x * force * accel / 1800
	extern_impulse.y = direction.y * force# * accel# * 35
	
