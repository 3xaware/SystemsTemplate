extends Node
class_name State

signal state_transition
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
