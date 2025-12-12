extends Node
class_name ItemDatabase

var items: Dictionary[StringName, ItemData] = {}

func register_item(item: ItemData) -> void:
	items[item.item_id] = item

func get_item(item_id: String) -> ItemData:
	return items.get(item_id)
