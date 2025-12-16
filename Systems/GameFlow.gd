extends Node

enum State {
	BOOT,
	MAIN_MENU,
	LOADING,
	GAMEPLAY,
	PAUSED
}

signal state_changed(previous: GameFlow.State, current: GameFlow.State)

var current_state: GameFlow.State = GameFlow.State.BOOT

func _ready() -> void:
        _set_state(GameFlow.State.BOOT)
        var bus: Node = get_node_or_null("/root/EventBus")
        if bus != null:
                bus.save_loaded.connect(_on_save_loaded)
        else:
                push_warning("GameFlow: EventBus autoload is missing; save_loaded will not update the game state.")

# ============================================================
#  PUBLIC API
# ============================================================

func set_state(new_state: GameFlow.State) -> void:
	if new_state == current_state:
		return

	var previous: GameFlow.State = current_state
	current_state = new_state
	state_changed.emit(previous, current_state)

func get_state() -> GameFlow.State:
	return current_state

func is_state(state: GameFlow.State) -> bool:
	return current_state == state

func is_gameplay() -> bool:
	return current_state == GameFlow.State.GAMEPLAY

func is_paused() -> bool:
	return current_state == GameFlow.State.PAUSED

func _on_save_loaded(_save_data: SaveData, _slot: int) -> void:
	set_state(GameFlow.State.LOADING)

# ============================================================
#  INTERNAL
# ============================================================

func _set_state(state: GameFlow.State) -> void:
	current_state = state
	state_changed.emit(GameFlow.State.BOOT, current_state)
