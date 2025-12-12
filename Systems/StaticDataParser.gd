extends Node
class_name StaticDataExtractor

var itemData: Dictionary = {}

func load_json_file(file_path: String) -> Dictionary:
	if FileAccess.file_exists(file_path):
		var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
		var text: String = file.get_as_text()
		var result: Variant = JSON.parse_string(text)
		
		if result is Dictionary:
			var dict_result: Dictionary = result
			itemData = dict_result
			return dict_result
		else:
			push_error("Invalid JSON format in: %s" % file_path)
	else:
		push_error("JSON file not found in: %s" % file_path)
	
	itemData = {}
	return {}
