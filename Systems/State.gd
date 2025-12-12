extends Node
class_name State

 signal state_transition(source_state: State, new_state_name: String)
var parent: Node

func Enter() -> void:
	pass
	
func Exit() -> void:
	pass
	
func OnInput(_event: InputEvent) -> void:
	pass
	
func Update(_delta : float) -> void:
	pass
	
func Physics_Update(_delta : float) -> void:
	pass
