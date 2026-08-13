extends RigidBody3D


@onready var mesh_instance_3d_node: MeshInstance3D = %MeshInstance3D:
	get():
		return mesh_instance_3d_node
@export var outline_material: Material


func set_highlight(active: bool) -> void:
	if not mesh_instance_3d_node:
		return

	if active:
		mesh_instance_3d_node.material_overlay = outline_material
	else:
		mesh_instance_3d_node.material_overlay = null
