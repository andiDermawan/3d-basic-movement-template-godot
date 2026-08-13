extends Node3D


signal camera_toggled(boolean)


@onready var x_camera_pivot_node: Node3D = %XCameraPivot
@onready var y_camera_pivot_node: Node3D = %YCameraPivot
@onready var spring_arm_3d_node: SpringArm3D = %SpringArm3D
@onready var ray_cast_3d_node: RayCast3D = %RayCast3D
@onready var fpp_camera_node: Camera3D = %FPPCamera:
	get():
		return fpp_camera_node
@onready var tpp_camera_node: Camera3D = %TPPCamera:
	get():
		return tpp_camera_node
@onready var pickable_object_location: Marker3D = %Marker3D
@export_enum("FPP", "TPP") var camera_mode: String = "FPP"
@export var player_model_node: Node3D
@export var camera_location: Marker3D
@export var follow_speed := 20.0
@export_range(0.0, 100.0) var camera_sensitivity: float = 50.0:
	get():
		return camera_sensitivity
var x_camera_pivot_basis: Basis:
	get():
		return x_camera_pivot_node.global_transform.basis
var held_object: Node3D = null
var hovered_object: Node3D = null


func _ready() -> void:
	camera_sensitivity /= 16667


func _process(delta: float) -> void:
	match camera_mode:
		"FPP":
			if camera_location:
				global_transform.origin = camera_location.global_transform.origin


func _physics_process(delta: float) -> void:
	if ray_cast_3d_node.is_colliding():
		var collider: Node3D = ray_cast_3d_node.get_collider()

		if  collider != hovered_object:
			clear_hovered_object()

			hovered_object = collider
			hovered_object.set_highlight(true)

		if Input.is_action_just_pressed("pick_object"):
			pick_object(collider)
	else:
		clear_hovered_object()

	if Input.is_action_just_pressed("drop_object"):
		drop_object()
	
	if held_object:
		held_object.global_position = pickable_object_location.global_position
		held_object.global_rotation = pickable_object_location.global_rotation


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		x_camera_pivot_node.rotate_y(-event.relative.x * camera_sensitivity)
		y_camera_pivot_node.rotate_x(-event.relative.y * camera_sensitivity)

		y_camera_pivot_node.rotation.x = clamp(y_camera_pivot_node.rotation.x, deg_to_rad(-60), deg_to_rad(60))

	if event.is_action_pressed("toggle_camera_mode"):
		match camera_mode:
			"FPP":
				camera_mode = "TPP"
				tpp_camera_node.make_current()

				camera_toggled.emit(false)
			"TPP":
				camera_mode = "FPP"
				fpp_camera_node.make_current()

				camera_toggled.emit(true)


func clear_hovered_object() -> void:
	if hovered_object:
		hovered_object.set_highlight(false)
		hovered_object = null


func pick_object(collider: Node3D) -> void:
	if held_object == null:
		held_object = collider
		held_object.mesh_instance_3d_node.set_layer_mask_value(1, false)
		held_object.mesh_instance_3d_node.set_layer_mask_value(4, true)
		held_object.freeze = true
		
		clear_hovered_object()
		
		ray_cast_3d_node.add_exception(held_object)
	else:
		drop_object()
		pick_object(collider)


func drop_object() -> void:
	if held_object != null:
		var throw_direction: Vector3 = (-fpp_camera_node.global_transform.basis.z).normalized()
		var throw_force: float = 1.0

		ray_cast_3d_node.remove_exception(held_object)

		held_object.mesh_instance_3d_node.set_layer_mask_value(1, true)
		held_object.mesh_instance_3d_node.set_layer_mask_value(4, false)
		held_object.freeze = false
		held_object.apply_central_impulse((throw_direction * throw_force) + get_parent().velocity)
		held_object = null
