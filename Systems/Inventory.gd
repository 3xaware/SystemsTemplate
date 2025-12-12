extends Node
class_name Inventory

signal inventory_updated(inventory: Array)

var max_slots: int
var slots: Array = []

func _init(max_slots: int = 28):
	max_slots = max(1, max_slots)
	self.max_slots = max_slots
	slots.resize(max_slots)
	for i in range(max_slots):
		slots[i] = null

func add_item(item_data: Dictionary) -> void:
        var item_id: String = item_data.get("item_id", "")
        var max_stack: int = item_data.get("max_stack", 1)

        for i in range(max_slots):
                var slot = slots[i]
                if slot and slot["item_id"] == item_id and slot["quantity"] < max_stack:
                        slot["quantity"] += 1
                        emit_signal("inventory_updated", slots)
                        return

	for i in range(max_slots):
		if slots[i] == null:
			slots[i] = {
				"item_id": item_id,
				"quantity": 1,
				"item_sprite_path": item_data.get("item_sprite_path", ""),
				"max_stack": max_stack,
			}
			emit_signal("inventory_updated", slots)
			return

	push_warning("Inventory full: %s" % item_id)

func load_inventory(data: Array) -> void:
	slots = []

	for item_data in data:
		slots.append(item_data.duplicate(true))

	while slots.size() < max_slots:
		slots.append(null)
	emit_signal("inventory_updated", slots)

func get_inventory_data() -> Array:
	var data: Array[Dictionary] = []
	for slot in slots:
		if slot != null:
			data.append(slot.duplicate(true))
	return data
