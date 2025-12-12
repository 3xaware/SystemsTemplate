extends Node

var blocked: bool = false

func block_input() -> void:
	blocked = true

func unblock_input() -> void:
	blocked = false

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
	if blocked:
		get_tree().set_input_as_handled()
