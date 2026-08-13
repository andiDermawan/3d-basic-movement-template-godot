extends CharacterBody3D
class_name PlayerCharacter


@onready var player_model_node: Node3D = %PlayerModel
@onready var camera_rig_node: Node3D = %CameraRig
@export var walk_speed: float = 2.0:
	get():
		return walk_speed
@export var movement_speed: float = 7.0:
	get():
		return movement_speed
@export var acceleration: float = 20.0
@export var deceleration: float = 8.0
@export var jump_velocity: float = 4.5


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player_model_node.global_transform.basis = camera_rig_node.x_camera_pivot_basis.orthonormalized()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player_model_node.global_transform.basis = player_model_node.global_transform.basis.slerp(camera_rig_node.x_camera_pivot_basis.orthonormalized(), get_process_delta_time() * 10.0)


func move_toward_direction(delta: float, direction: Vector3, speed: float) -> void:
	direction = (camera_rig_node.x_camera_pivot_basis * direction).normalized()
	
	if direction:
		# [Normal TPP]
		#var target_transform = global_transform.looking_at(transform.origin + direction, Vector3.UP)
		#global_transform.basis = global_transform.basis.slerp(target_transform.basis, delta * 10.0)

		# [Strafe TPP]
		velocity.x = move_toward(velocity.x, direction.x * speed, delta * acceleration)
		velocity.z = move_toward(velocity.z, direction.z * speed, delta * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0.0, delta * deceleration)
		velocity.z = move_toward(velocity.z, 0.0, delta * deceleration)
		if velocity.length() == 0.0:
			velocity = Vector3.ZERO


func move_upward() -> void:
	velocity.y = jump_velocity


func is_falling() -> bool:
	return velocity.y < 0.0
