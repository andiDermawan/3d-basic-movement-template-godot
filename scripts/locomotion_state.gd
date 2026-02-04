extends State


func _ready() -> void:
	pass


func _physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	direction = (character_node.get_x_camera_pivot_basis() * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	character_node.move_toward_direction(direction)
	
	animation_tree_node.set(animation_condition_path, true)
	animation_tree_node.set(animation_blend_path, character_node.get_velocity().length()/character_node.get_movement_speed())

	if character_node.is_falling():
		state_machine_node.change_state(STATE.INAIR)

	character_node.move_and_slide()


func _enter() -> void:
	pass


func _exit() -> void:
	animation_tree_node.set(animation_condition_path, false)


func _input_handle(event: InputEvent) -> void:
	if Input.is_action_pressed("move_jump"):
		state_machine_node.change_state(STATE.INAIR)
