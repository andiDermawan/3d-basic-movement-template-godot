extends GroundedState


func _ready() -> void:
	pass


func _physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	if not input_dir.length():
		state_machine_node.change_state(STATE.IDLE)
	elif Input.is_action_pressed("move_run") and input_dir.y == -1:
		state_machine_node.change_state(STATE.RUN)

	direction = Vector3(input_dir.x, 0, input_dir.y)
	character_node.move_toward_direction(delta, direction, character_node.walk_speed)

	#animation_tree_node.set(animation_condition_path, true)

	# [Normal TPP]
	#var target_blend = character_node.velocity.length() / character_node.get_movement_speed()
	#var current_blend = animation_tree_node.get(animation_blend_path)
	#var new_blend = lerp(current_blend, target_blend, delta * 10.0)
	#animation_tree_node.set(animation_blend_path, new_blend)
	# [Strafe TPP]
	var velocity: Vector3 = character_node.player_model_node.global_transform.basis.inverse() * character_node.velocity
	var target_blend: Vector2 = Vector2(velocity.x, -velocity.z) / character_node.walk_speed
	target_blend = target_blend.clamp(Vector2(-1, -1), Vector2(1, 1))
	var current_blend: Vector2 = animation_tree_node.get(animation_blend_path)
	var new_blend: Vector2 = current_blend.lerp(target_blend, delta * 5.0)

	animation_tree_node.set(animation_blend_path, new_blend)

	if character_node.is_falling():
		state_machine_node.change_state(STATE.JUMP)

	character_node.move_and_slide()


func _enter() -> void:
	animation_tree_node.set(animation_condition_path, true)


func _exit() -> void:
	animation_tree_node.set(animation_condition_path, false)


func _input_handle(event: InputEvent) -> void:
	if event.is_action_pressed("move_jump"):
		state_machine_node.change_state(STATE.JUMP)
