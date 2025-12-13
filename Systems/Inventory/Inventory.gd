extends Node
class_name Inventory

@export var max_slots: int = 28
var slots: Array[ItemStack] = []

func _ready() -> void:
	_initialize_slots()
	_load_database()

func _initialize_slots() -> void:
	slots = []
	slots.resize(max_slots)

	for i: int in range(max_slots):
		slots[i] = null

func _load_database() -> bool:
	if not Engine.has_singleton("ItemDataBase"):
		push_error("Inventory ERROR: ItemDataBase autoload is missing! Add it in Project > Autoloads.")
		return false

	return true

func _broadcast_inventory_updated() -> void:
	if Engine.has_singleton("EventBus"):
		EventBus.emit_signal("inventory_updated", slots)
	else:
		push_warning("Inventory: EventBus autoload is missing; global inventory updates will not be broadcast.")

func add_item(item: ItemData, amount: int = 1) -> void:
	for i: int in range(max_slots):
		var stack: ItemStack = slots[i]
		if stack != null and stack.item == item and not stack.is_full():
			amount = _add_to_stack(stack, amount)
			if amount <= 0:
				_broadcast_inventory_updated()
				return

	for i: int in range(max_slots):
		if slots[i] == null:
			var new_stack: ItemStack = ItemStack.new()
			new_stack.item = item
			new_stack.quantity = 0

			amount = _add_to_stack(new_stack, amount)
			slots[i] = new_stack

			if amount <= 0:
				_broadcast_inventory_updated()
				return

		push_warning("Inventory FULL: Cannot add item '%s'" % item.item_id)
		_broadcast_inventory_updated()

func _add_to_stack(stack: ItemStack, amount: int) -> int:
	var space: int = stack.item.max_stack - stack.quantity
	var to_add: int = min(amount, space)
	stack.quantity += to_add
	return amount - to_add

func get_inventory_data() -> Array[Dictionary]:
	var data: Array[Dictionary] = []

	for stack: ItemStack in slots:
		if stack != null:
			var entry: Dictionary = {
				"item_id": stack.item.item_id,
				"quantity": stack.quantity
			}
			data.append(entry)

	return data

func load_inventory(data: Array[Dictionary]) -> void:
	_initialize_slots()

	if not _load_database():
		return

	for entry: Dictionary in data:
		var item_id: String = entry.get("item_id", "")
		var amount: int = int(entry.get("quantity", 1))

		var item: ItemData = ItemDataBase.get_item(item_id)
		if item != null:
			add_item(item, amount)
		else:
			push_warning("Inventory WARNING: Item ID '%s' not found in ItemDataBase." % item_id)

	_broadcast_inventory_updated()
