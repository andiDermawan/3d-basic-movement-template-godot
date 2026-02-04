extends Control


@onready var label_state_node: Label = $LabelState


func _on_state_machine_state_changed(state: Variant) -> void:
	label_state_node.text = "State: " + state
