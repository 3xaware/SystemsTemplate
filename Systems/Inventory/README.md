# Sistema de inventario

Permite almacenar `ItemStack` apilables en un número fijo de ranuras y emite una señal cuando cambia el contenido.

## Componentes
- **ItemData.gd** (`Resource`): define un ítem individual (ID, nombre, icono, descripción y tamaño máximo de pila).
- **ItemStack.gd** (`Resource`): representa una pila de un `ItemData` con cantidad y utilidades (`is_full`, `add`, `remove`).
- **ItemDatabase.gd** (`Node`): almacén de ítems registrados, pensado para autoload.
- **Inventory.gd** (`Node`): administra las ranuras y la interacción con la base de datos.

## Preparación en Godot
1. **Crear autoload de ItemDatabase**
   - En *Project > Autoloads*, agrega `Systems/Inventory/ItemDataBase.gd` con el nombre `ItemDatabase`.
   - Registra los ítems en `ready()` de la base de datos o desde un cargador externo (por ejemplo, usando `StaticDataExtractor` para leer un JSON y luego crear `ItemData`).
2. **Instanciar Inventory**
   - Añade un nodo `Inventory` a tu escena (por ejemplo, como hijo del jugador o de un gestor de UI).
   - Ajusta `max_slots` según la capacidad deseada.
3. **Conectar la señal**
   - Conecta `inventory_updated(slots)` a la interfaz o lógica que deba reaccionar ante cambios.

## Uso común
- **Agregar ítems**
  ```gdscript
  var sword: ItemData = ItemDatabase.get_item("sword")
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
- Sin la autoload `ItemDatabase`, `Inventory` registrará un error y no podrá reconstruir ítems al cargar partidas.
- `ItemStack.is_full()` usa `item.max_stack`; ajusta ese campo en cada `ItemData` para controlar el límite.
- Usa la señal `inventory_updated` para refrescar la UI o reproducir sonidos cuando se añadan o retiren objetos.
