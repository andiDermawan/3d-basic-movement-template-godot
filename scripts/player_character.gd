extends CharacterBody3D
class_name PlayerCharacter


@export var movement_speed: float = 5.0
@export var acceleration: float = 20.0
@export var deceleration: float = 8.0
@export var jump_velocity: float = 4.5
@export var camera_rig_node: Node3D = null


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0


func move_toward_direction(direction: Vector3) -> void:
	if direction:
		var target_transform = global_transform.looking_at(transform.origin + direction, Vector3.UP)
		global_transform.basis = global_transform.basis.slerp(target_transform.basis, get_physics_process_delta_time() * 10.0)
		velocity.x = move_toward(velocity.x, direction.x * movement_speed, get_physics_process_delta_time() * acceleration)
		velocity.z = move_toward(velocity.z, direction.z * movement_speed, get_physics_process_delta_time() * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0.0, get_physics_process_delta_time() * deceleration)
		velocity.z = move_toward(velocity.z, 0.0, get_physics_process_delta_time() * deceleration)
		if velocity.length() == 0.0:
			velocity = Vector3.ZERO


func move_upward() -> void:
	velocity.y = jump_velocity


func is_falling() -> bool:
	return velocity.y < 0.0


func get_movement_speed() -> float:
	return movement_speed


func get_jump_velocity() -> float:
	return jump_velocity


func get_x_camera_pivot_basis() -> Basis:
	return camera_rig_node.get_x_camera_pivot_basis()
