extends Node
signal state_changed(state)


@onready var state_nodes: Array = [$LocomotionState, $InAirState]
var current_state_node: Node = null


func _ready() -> void:
	change_state(0)


func _physics_process(delta: float) -> void:
	if current_state_node:
		current_state_node._physics_update(delta)


func change_state(new_state: int) -> void:
	if current_state_node:
		current_state_node._exit()

	state_changed.emit(state_nodes[new_state].name)
	current_state_node = state_nodes[new_state]
	current_state_node._enter()


func _input(event: InputEvent) -> void:
	if current_state_node:
		current_state_node._input_handle(event)
