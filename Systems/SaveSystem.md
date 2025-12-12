# Sistema de guardado (SaveSystem)

El `SaveSystem.gd` es un nodo utilitario que centraliza la carga/creación, guardado y borrado de partidas usando recursos `SaveData` en la carpeta `user://saves/`.

## Estructura
- **SaveData.gd**: Recurso con los campos persistentes. Incluye el arreglo `saved_inventory` y puedes añadir cualquier otro dato que quieras conservar.
- **SaveSystem.gd**: Nodo que opera sobre un `SaveData` activo (`current_save_data`) y un número de ranura (`current_slot`).
- **StaticDataParser.gd**: Nodo auxiliar para cargar diccionarios desde JSON cuando necesites poblar datos estáticos (por ejemplo, ítems o configuraciones) antes de guardar/cargar.

## Configuración rápida
1. **Añade el nodo** `SaveSystem` a un autoload o a la escena raíz para tenerlo disponible en todo momento.
2. **Configura las ranuras**: las partidas se guardan en `user://saves/save_slot_{N}.tres`; no necesitas crear la carpeta manualmente, `verify_save_directory()` lo hace al iniciar.
3. **Extiende `SaveData`** añadiendo nuevas variables para todo lo que desees persistir.

## Flujo de uso
- **Cargar o crear una ranura**
  ```gdscript
  $SaveSystem.load_save(0) # Carga la ranura 0, o crea una nueva si no existe
  var save: SaveData = $SaveSystem.current_save_data
  ```
- **Actualizar datos y guardar**
  ```gdscript
  save.player_position = player.global_position
  save.saved_inventory = inventory.get_inventory_data()
  $SaveSystem.save_current()
  ```
- **Eliminar una ranura**
  ```gdscript
  $SaveSystem.delete_save(2)
  ```

## Detalles de API
- `load_save(slot: int)`
  - Establece `current_slot`, intenta cargar el archivo de la ruta generada por `get_save_path(slot)` y, si no existe, crea un `SaveData` nuevo y lo guarda de inmediato.
- `save_current()`
  - Serializa `current_save_data` en la ranura activa. Muestra un error si el guardado falla.
- `delete_save(slot: int)`
  - Borra el archivo de la ranura indicada si existe.
- `get_save_path(slot: int) -> String`
  - Devuelve la ruta completa de la ranura, útil si necesitas comprobar su existencia manualmente.

## Integración con otros sistemas
- **Inventario**: usa `Inventory.get_inventory_data()` para almacenar los ítems en `SaveData.saved_inventory` y luego `Inventory.load_inventory(save.saved_inventory)` al cargar la partida.
- **Datos estáticos**: con `StaticDataParser.load_json_file(ruta)` puedes precargar definiciones (por ejemplo, ítems) antes de reconstruir el estado dinámico al cargar.

## Prácticas recomendadas
- Llama a `load_save()` al iniciar el juego o al seleccionar la ranura en el menú principal.
- Después de modificar `current_save_data`, invoca `save_current()` inmediatamente para evitar pérdidas.
- Agrega solo tipos serializables a `SaveData` (números, cadenas, diccionarios, recursos). Si necesitas nodos, guarda referencias indirectas (por ejemplo, nombres o rutas) y resuélvelas al cargar.
