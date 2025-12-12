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
