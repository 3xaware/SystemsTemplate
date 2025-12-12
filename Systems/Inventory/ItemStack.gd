extends Resource
class_name ItemStack

@export var item: ItemData
@export var quantity: int = 1

func is_full() -> bool:
	return quantity >= item.max_stack

func add(amount: int) -> int:
	var remaining := 0
	quantity += amount
	if quantity > item.max_stack:
		remaining = quantity - item.max_stack
		quantity = item.max_stack
	return remaining

func remove(amount: int) -> void:
	quantity = max(quantity - amount, 0)

func is_empty() -> bool:
	return quantity <= 0
