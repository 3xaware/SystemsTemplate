# Sistema de inventario (Español)

Permite almacenar `ItemStack` apilables en un número fijo de ranuras y emite una señal global cuando cambia el contenido.

## Componentes
- **ItemData.gd** (`Resource`): define un ítem individual (ID, nombre, icono, descripción y tamaño máximo de pila).
- **ItemStack.gd** (`Resource`): representa una pila de un `ItemData` con cantidad y utilidades (`is_full`, `add`, `remove`).
- **ItemDataBase.gd** (`Node`): almacén de ítems registrados, pensado para autoload.
- **Inventory.gd** (`Node`): administra las ranuras y la interacción con la base de datos.

## Preparación en Godot
1. **Crear autoload de ItemDataBase**
   - En *Project > Autoloads*, agrega `Systems/Inventory/ItemDataBase.gd` con el nombre `ItemDataBase`.
   - Registra los ítems en `ready()` de la base de datos o desde un cargador externo (por ejemplo, usando `StaticDataParser` para leer un JSON y luego crear `ItemData`).
2. **Instanciar Inventory**
   - Añade un nodo `Inventory` a tu escena (por ejemplo, como hijo del jugador o de un gestor de UI).
   - Ajusta `max_slots` según la capacidad deseada.
3. **Conectar la señal**
   - Conecta `EventBus.inventory_updated(slots)` a la interfaz o lógica que deba reaccionar ante cambios.

## Uso común
- **Agregar ítems**
  ```gdscript
  var sword: ItemData = ItemDataBase.get_item("sword")
  $Inventory.add_item(sword, 3)
  ```
  El sistema intentará rellenar pilas existentes del mismo ítem y luego crear nuevas ranuras si hay espacio. Si el inventario está lleno, mostrará una advertencia.

- **Obtener datos serializables**
  ```gdscript
  var data: Array[Dictionary] = $Inventory.get_inventory_data()
  # Útil para guardado en SaveData.saved_inventory
  ```

- **Cargar desde datos persistidos**
  ```gdscript
  $Inventory.load_inventory(save.saved_inventory)
  ```
  El método reinicia las ranuras, valida la base de datos y agrega cada entrada con `add_item` para respetar la lógica de apilado.

## Consejos de integración
- Sin la autoload `ItemDataBase`, `Inventory` registrará un error y no podrá reconstruir ítems al cargar partidas.
- `ItemStack.is_full()` usa `item.max_stack`; ajusta ese campo en cada `ItemData` para controlar el límite.
- Usa la señal global `EventBus.inventory_updated` para refrescar la UI o reproducir sonidos cuando se añadan o retiren objetos.

---

# Inventory system (English)

Allows storing stackable `ItemStack` instances in a fixed number of slots and emits a global signal when the contents change.

## Components
- **ItemData.gd** (`Resource`): defines a single item (ID, name, icon, description, and maximum stack size).
- **ItemStack.gd** (`Resource`): represents a stack of an `ItemData` with amount and utilities (`is_full`, `add`, `remove`).
- **ItemDataBase.gd** (`Node`): registry of items, intended as an autoload.
- **Inventory.gd** (`Node`): manages slots and interaction with the database.

## Godot setup
1. **Create ItemDataBase autoload**
   - In *Project > Autoloads*, add `Systems/Inventory/ItemDataBase.gd` with the name `ItemDataBase`.
   - Register items in the database's `ready()` or through an external loader (for example, using `StaticDataParser` to read JSON and then create `ItemData`).
2. **Instantiate Inventory**
   - Add an `Inventory` node to your scene (e.g., as a child of the player or a UI manager).
   - Adjust `max_slots` to the desired capacity.
3. **Connect the signal**
   - Connect `EventBus.inventory_updated(slots)` to the UI or logic that should react to changes.

## Common usage
- **Add items**
  ```gdscript
  var sword: ItemData = ItemDataBase.get_item("sword")
  $Inventory.add_item(sword, 3)
  ```
  The system will try to fill existing stacks of the same item and then create new slots if there is space. If the inventory is full, it will warn you.

- **Get serializable data**
  ```gdscript
  var data: Array[Dictionary] = $Inventory.get_inventory_data()
  # Useful for saving into SaveData.saved_inventory
  ```

- **Load from persisted data**
  ```gdscript
  $Inventory.load_inventory(save.saved_inventory)
  ```
  The method resets slots, validates the database, and adds each entry with `add_item` to respect stacking logic.

## Integration tips
- Without the `ItemDataBase` autoload, `Inventory` will log an error and cannot rebuild items when loading saves.
- `ItemStack.is_full()` uses `item.max_stack`; adjust that field in each `ItemData` to control the limit.
- Use the global `EventBus.inventory_updated` signal to refresh UI or play sounds when items are added or removed.
