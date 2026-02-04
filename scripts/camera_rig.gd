extends Node3D


@onready var x_camera_pivot_node: Node3D = %XCameraPivot
@onready var y_camera_pivot_node: Node3D = %YCameraPivot
@onready var spring_arm_3d_node: SpringArm3D = %SpringArm3D
@export var target_node: Node3D
@export var offset: Vector3 = Vector3(0, 1.5, 0)
@export var follow_speed := 20.0
@export_range(0.0, 100.0) var camera_sensitivity: float = 50.0:
	get():
		return camera_sensitivity / 16667


func _ready() -> void:
	var player_forward = target_node.global_transform.basis.z
	var yaw = atan2(player_forward.x, player_forward.z)
	x_camera_pivot_node.rotation.y = yaw


func _process(delta: float) -> void:
	if target_node:
		var target_pos = target_node.global_transform.origin + offset
		global_transform.origin = target_pos


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		x_camera_pivot_node.rotate_y(-event.relative.x * camera_sensitivity)
		y_camera_pivot_node.rotate_x(-event.relative.y * camera_sensitivity)

	y_camera_pivot_node.rotation.x = clamp(y_camera_pivot_node.rotation.x, deg_to_rad(-60), deg_to_rad(60))


func get_x_camera_pivot_basis() -> Basis:
	return x_camera_pivot_node.global_transform.basis
