extends State


func _ready() -> void:
	pass


func _physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("move_jump") and character_node.is_on_floor():
		character_node.move_upward()

	if character_node.is_on_floor() and character_node.get_velocity().y <= 0.0:
		state_machine_node.change_state(STATE.LOCOMOTION)

	character_node.move_and_slide()


func _enter() -> void:
	animation_tree_node.set(animation_condition_path, true)


func _exit() -> void:
	animation_tree_node.set(animation_condition_path, false)


func _input_handle(event: InputEvent) -> void:
	pass
