extends Node
class_name State


@export var character_node: CharacterBody3D = null
@export var state_machine_node: Node = null
@export var animation_tree_node: AnimationTree
@export var animation_blend_path: String
@export var animation_condition_path: String
var direction: Vector3
enum STATE {LOCOMOTION, INAIR}


func _enter_tree() -> void:
	if state_machine_node == null:
		state_machine_node = get_parent()
	if character_node == null:
		if state_machine_node.get_parent() is CharacterBody3D:
			character_node = state_machine_node.get_parent()


func _physics_update(delta: float) -> void:
	pass


func _enter() -> void:
	pass


func _exit() -> void:
	pass


func _input_handle(event : InputEvent) -> void:
	pass
