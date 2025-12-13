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
