# Sistema de interacción

Permite gestionar acciones contextuales con objetos cercanos mediante áreas de detección.

## Componentes
- **Interactable.gd** (`Area2D`): área interactuable con nombre mostrado y bandera de disponibilidad.
  - Propiedades exportadas: `interact_name` (texto que verá el jugador) e `is_interactable` (habilita/inhabilita la acción).
  - Define un `Callable interact` que puedes sustituir en cada instancia con la lógica que debe ejecutarse al interactuar.
- **InteractingComponent.gd** (`Node2D`): componente que se coloca en el jugador u origen de la interacción.
  - Tiene un `Label` hijo (`InteractLabel`) que muestra el nombre del interactuable actual.
  - Señal `interacted(area: Area2D)` emitida tras ejecutar la interacción.

## Configuración en escena
1. **Jugador o emisor de interacciones**
   - Añade la escena `InteractingComponent.tscn` como hijo del nodo jugador (o instancia `InteractingComponent.gd` y vincula un `Label` llamado `InteractLabel`).
   - Define un `Area2D` de rango (por ejemplo, un hijo de colisión) y conecta sus señales `area_entered` y `area_exited` a `_on_interact_range_area_entered` y `_on_interact_range_area_exited` respectivamente.
2. **Objetos interactuables**
   - Instancia nodos `Interactable` en el mundo y ajusta `interact_name` e `is_interactable`.
   - Asigna el `Callable interact` en tiempo de ejecución o en `_ready()` del propio nodo:
	 ```gdscript
	 func _ready():
		 interact = func():
			 open_chest()
	 ```

## Flujo de interacción
- El componente mantiene una lista `current_interactions` con las áreas en rango.
- En `_process`, ordena por proximidad y muestra el `InteractLabel` con el nombre del interactuable más cercano y disponible.
- Cuando el jugador pulsa la acción `interact` (configurada en el mapa de entrada del proyecto) y `can_interact` es verdadero:
  1. Desactiva temporalmente nuevas interacciones (`can_interact = false`).
  2. Oculta la etiqueta, ejecuta el `Callable` del primer interactuable y espera si es asíncrono.
  3. Emite la señal `interacted` con el `Area2D` usado y reactiva la posibilidad de interactuar.

## Buenas prácticas
- Asegúrate de que la acción "interact" está definida en **Project Settings > Input Map**.
- Cambia `is_interactable` a `false` cuando quieras deshabilitar un objeto sin retirarlo del mundo.
- Si la lógica de `interact` puede tardar (por ejemplo, mostrar diálogos asíncronos), aprovecha el `await` para bloquear nuevas interacciones hasta terminar.

---

# Interaction system (English)

Handles contextual actions with nearby objects through detection areas.

## Components
- **Interactable.gd** (`Area2D`): interactable area with display name and availability flag.
  - Exported properties: `interact_name` (text the player sees) and `is_interactable` (enables/disables the action).
  - Defines a `Callable interact` you can override in each instance with the logic to execute upon interaction.
- **InteractingComponent.gd** (`Node2D`): component placed on the player or interaction origin.
  - Has a child `Label` (`InteractLabel`) that shows the current interactable name.
  - Signal `interacted(area: Area2D)` emitted after executing the interaction.

## Scene setup
1. **Player or interaction emitter**
   - Add the `InteractingComponent.tscn` scene as a child of the player node (or instance `InteractingComponent.gd` and link a `Label` named `InteractLabel`).
   - Define a range `Area2D` (for example, a collision child) and connect its `area_entered` and `area_exited` signals to `_on_interact_range_area_entered` and `_on_interact_range_area_exited` respectively.
2. **Interactable objects**
   - Instance `Interactable` nodes in the world and adjust `interact_name` and `is_interactable`.
   - Assign the `Callable interact` at runtime or in the node's `_ready()`:
         ```gdscript
         func _ready():
                 interact = func():
                         open_chest()
         ```

## Interaction flow
- The component keeps a `current_interactions` list with areas in range.
- In `_process`, it orders by proximity and shows `InteractLabel` with the name of the closest available interactable.
- When the player presses the `interact` action (configured in the project's input map) and `can_interact` is true:
  1. Temporarily disables new interactions (`can_interact = false`).
  2. Hides the label, runs the interactable's `Callable`, and awaits if it is asynchronous.
  3. Emits the `interacted` signal with the `Area2D` used and re-enables interaction.

## Best practices
- Ensure the "interact" action is defined under **Project Settings > Input Map**.
- Toggle `is_interactable` to `false` when you want to disable an object without removing it from the world.
- If `interact` logic can take time (for example, showing asynchronous dialogues), use `await` to block new interactions until it finishes.
