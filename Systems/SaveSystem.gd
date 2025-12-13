extends Node
class_name SaveSystem

var current_save_data: SaveData = null
var current_slot: int = -1

const SAVE_DIR: String = "user://saves/"
const SAVE_FILE_PATTERN: String = "save_slot_{0}.tres"

func _ready() -> void:
	verify_save_directory()

func verify_save_directory() -> void:
	DirAccess.make_dir_absolute(SAVE_DIR)

func get_save_path(slot: int) -> String:
	return SAVE_DIR + SAVE_FILE_PATTERN.format([slot])

func load_save(slot: int) -> void:
	current_slot = slot
	var path: String = get_save_path(slot)

	if FileAccess.file_exists(path):
		var resource: Resource = ResourceLoader.load(path)
		var save: SaveData = resource.duplicate(true) as SaveData
		current_save_data = save
		print("Save successfully loaded ", slot)
		if Engine.has_singleton("EventBus"):
			EventBus.emit_signal("save_loaded", current_save_data, current_slot)
	else:
		print("Non-existent save in slot ", slot, ", creating new.")
		current_save_data = SaveData.new()
		save_current()

func save_current() -> void:
	if current_save_data != null:
		var path: String = get_save_path(current_slot)
		var err: Error = ResourceSaver.save(current_save_data, path)
		if err != OK:
			push_error("Error saving game in slot " + str(current_slot))
		else:
			print("Game saved successfully in slot ", current_slot)
			if Engine.has_singleton("EventBus"):
				EventBus.emit_signal("save_saved", current_save_data, current_slot)

func delete_save(slot: int) -> void:
	var path: String = get_save_path(slot)
	if FileAccess.file_exists(path):
		var err: Error = DirAccess.remove_absolute(path)
		if err != OK:
			push_error("Error deleting save in slot " + str(slot))
		else:
			print("Save slot ", slot, " successfully deleted.")
			if Engine.has_singleton("EventBus"):
				EventBus.emit_signal("save_deleted", slot)
	else:
		print("Non-existent save in slot ", slot)
