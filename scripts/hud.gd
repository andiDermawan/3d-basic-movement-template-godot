extends Control


@onready var label_state_node: Label = %LabelState
@onready var dot_indicator: Panel = %DotIndicator

func _on_state_machine_state_changed(state: String) -> void:
	label_state_node.text = "State: " + state


func _on_camera_rig_camera_toggled(boolean: bool) -> void:
	dot_indicator.visible = boolean
