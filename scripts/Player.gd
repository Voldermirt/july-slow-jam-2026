extends CharacterBody2D

@export_group("Movement Parameters")
@export var speed : float = 120 # Pixels per second
@export var accel : float = 80 # Pixels per second per second
@export_subgroup("Jump Parameters")
# Used to calculate the actual physical parameters for the jump
@export var jump_height : float = 128 # In pixels
@export var time_to_peak_seconds : float = 0.5 # In seconds, obviously
@export var time_to_ground_seconds : float = 0.25 # Derives the general gravity
@export var variable_jump_height := true
@export var max_coyote_time : float = 0.05
@export var max_jump_buffer : float = 0.05

var jump_force : float
var gravity : float # Gravity used while the player is falling
var jump_gravity : float # The gravity used while the player is jumping up

var coyote_timer := 0.0
var jump_buffer_timer := 0.0
var was_on_floor := false # Was the player on the floor last frame?
var is_jumping := false

func _ready() -> void:
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


func _physics_process(delta: float) -> void:	
	horizontal_movement(delta)
	jump(delta)
	
	apply_velocity(delta)

# Gets the target horizontal movement velocity from the player's input
func horizontal_movement(delta: float):
	var vel := 0.0
	if Input.is_action_pressed("left"):
		vel -= speed
	if Input.is_action_pressed("right"):
		vel += speed
	
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
		

func apply_velocity(delta : float):
	coyote_timer = max(coyote_timer - delta, 0)
	jump_buffer_timer = max(jump_buffer_timer - delta, 0)
	
	if not is_on_floor() and was_on_floor and velocity.y >= 0:
			coyote_timer = max_coyote_time
	
	was_on_floor = is_on_floor()
	move_and_slide()
