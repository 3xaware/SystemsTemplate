extends Node

# Shared signals for cross-system communication
signal inventory_updated(slots: Array[ItemStack])
signal save_loaded(save_data: SaveData, slot: int)
signal save_saved(save_data: SaveData, slot: int)
signal save_deleted(slot: int)
signal scene_loaded(scene: Node)
