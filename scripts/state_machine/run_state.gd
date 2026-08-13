extends GroundedState


func _physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	if not input_dir.length():
		state_machine_node.change_state(STATE.IDLE)

	if input_dir.y == -1:
		direction = Vector3(0, 0, input_dir.y)
	else:
		state_machine_node.change_state(STATE.LOCOMOTION)

	character_node.move_toward_direction(delta, direction, character_node.movement_speed)
	
	var target_blend = character_node.velocity.length() / character_node.movement_speed
	var current_blend = animation_tree_node.get(animation_blend_path)
	var new_blend = lerp(current_blend, target_blend, delta * 10.0)

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
	if event.is_action_released("move_run"):
		state_machine_node.change_state(STATE.LOCOMOTION)
