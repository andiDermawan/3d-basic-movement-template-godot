extends GroundedState


func _physics_update(_delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	if Input.is_action_pressed("move_run") and input_dir.y == -1:
		state_machine_node.change_state(STATE.RUN)
	elif input_dir.length():
		state_machine_node.change_state(STATE.LOCOMOTION)

func _enter() -> void:
	animation_tree_node.set(animation_condition_path, true)


func _exit() -> void:
	animation_tree_node.set(animation_condition_path, false)


func _input_handle(event: InputEvent) -> void:
	if event.is_action_pressed("move_jump"):
		state_machine_node.change_state(STATE.JUMP)
