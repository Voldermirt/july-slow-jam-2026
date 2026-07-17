class_name SpringItem extends BaseItem


@export var rotation_range : float = 20.0 # Means goes from -20.0 to 20.0
@export var min_force : float = 1000.0
@export var max_force : float = 1250.0

var spring_force : float = 0.0

func _init() -> void:
	super._init()
	#freeze = true

func _ready() -> void:
	super._ready()

func knock_down(velocity: Vector2) -> void:
	#freeze = false
	super.knock_down(velocity)

func drop(direction: int) -> void:
	super.drop(direction)

func on_land() -> void:
	super.on_land()
	
	await get_tree().process_frame
	rotation_degrees = randf_range(-20.0, 20.0)
	spring_force = randf_range(min_force, max_force)

func apply_player_impulse(player : Player):
	var direction := Vector2.UP.rotated(global_rotation).normalized()
	player.apply_impulse(direction, spring_force)

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	apply_player_impulse(body as Player)
