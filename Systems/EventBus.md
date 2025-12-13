# Sistema de eventos (Español)

El `EventBus.gd` es un nodo global (autoload) que actúa como **canal de comunicación desacoplado** entre los distintos sistemas del juego. Permite emitir y escuchar eventos globales sin que los sistemas se conozcan entre sí ni mantengan referencias directas.

Su función principal es **reemplazar patrones de coordinación centralizada** (como un GameManager que conoce todo) por un modelo basado en eventos, más modular y escalable.

El EventBus:
- No contiene lógica de juego.
- No toma decisiones.
- No coordina sistemas.
- Solo expone señales y las retransmite.

Los sistemas interesados deciden de forma independiente cómo reaccionar a cada evento.

Se utiliza principalmente para comunicar:
- Cambios de estado globales.
- Eventos de gameplay.
- Solicitudes entre sistemas (guardado, cambio de escena, etc.).
- Notificaciones que pueden interesar a múltiples subsistemas.

## Señales incluidas
- `inventory_updated(slots: Array[ItemStack])`: se emite cuando el inventario cambia, enviando las ranuras resultantes.
- `save_loaded(save_data: SaveData, slot: int)`: indica que una ranura se cargó (o se creó) y ya está disponible.
- `save_saved(save_data: SaveData, slot: int)`: confirma que el guardado de la ranura activa terminó correctamente.
- `save_deleted(slot: int)`: informa que una ranura fue eliminada.
- `scene_loaded(scene: Node)`: avisa que una escena terminó de cargarse, útil para HUD o sistemas dependientes de la escena.

## Uso rápido
1. Añade `EventBus` como autoload en el proyecto.
2. Emite eventos desde cualquier lugar, por ejemplo: `EventBus.save_saved.emit(save, 0)`.
3. Conecta las señales en los sistemas interesados para reaccionar sin dependencias directas.

---

# Event system (English)

`EventBus.gd` is a global node (autoload) that serves as a **decoupled communication channel** between game systems. It allows global events to be emitted and listened to without systems knowing about each other or holding direct references.

Its main purpose is to **replace centralized coordination patterns** (such as a GameManager that knows everything) with an event-based model that is more modular and scalable.

The EventBus:
- Contains no game logic.
- Makes no decisions.
- Does not coordinate systems.
- Only exposes and broadcasts signals.

Interested systems independently decide how to react to each event.

It is mainly used to communicate:
- Global state changes.
- Gameplay events.
- Requests between systems (saving, scene changes, etc.).
- Notifications that may be relevant to multiple subsystems.

## Included signals
- `inventory_updated(slots: Array[ItemStack])`: emitted when the inventory changes, providing the resulting slots.
- `save_loaded(save_data: SaveData, slot: int)`: indicates that a slot was loaded (or created) and is ready to use.
- `save_saved(save_data: SaveData, slot: int)`: confirms that saving the active slot finished successfully.
- `save_deleted(slot: int)`: reports that a slot was deleted.
- `scene_loaded(scene: Node)`: notifies that a scene has finished loading, useful for HUD or scene-dependent systems.

## Quick usage
1. Add `EventBus` as an autoload in the project.
2. Emit events from anywhere, e.g., `EventBus.save_saved.emit(save, 0)`.
3. Connect the signals in interested systems to react without direct dependencies.
