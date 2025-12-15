extends Node
class_name StateMachine

var machine_initialized: bool = false
var flag: bool = false
var states: Dictionary = {}
var current_state: State
@export var initial_state: State

func init(parent: Node) -> void:
	if !parent:
		print("StateMachine: Parent is null")
	
	for child: State in get_children():
		if child is State:
			child.parent = parent
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
			
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
	else:
		print("StateMachine: No initial state asigned")
		return
	
	if initial_state and parent:
		print(self.name, ": State Machine succesfully initialized")
		machine_initialized = true
	
func change_state(source_state: State, new_state_name: String)  -> void:
	if source_state != current_state:
		print("Invalid change_state from: " + source_state.name + " but currently in: " + current_state.name)
		return
		
	var new_state: State = states.get(new_state_name.to_lower())
	if !new_state:
		print("StateMachine: State " + new_state_name + " does not exist")
		return
	
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	current_state = new_state
	
func _input(event: InputEvent) -> void:
	if current_state:
		current_state.OnInput(event)
	
func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)
	elif !machine_initialized and !flag:
		print("StateMachine: State Machine was not initialized")
		flag = true

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)
