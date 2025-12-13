# Sistemas base del proyecto (Español)

Este directorio contiene plantillas reutilizables para sistemas habituales en Godot. Cada sección resume el propósito de los archivos y enlaza a instrucciones más detalladas en los subdirectorios correspondientes.

- **SaveSystem / SaveData**: Guardado y carga de datos del juego mediante recursos `.tres`. Consulta [SaveSystem.md](SaveSystem.md).
- **StaticDataParser**: Utilidad para leer datos estáticos desde archivos JSON. Se documenta en [SaveSystem.md](SaveSystem.md) porque suele alimentar inventarios u otros sistemas persistentes.
- **Inventory**: Gestión de ítems apilables, con base de datos de ítems y señal de actualización. Ver [Inventory/README.md](Inventory/README.md).
- **InteractionSystem**: Interacciones cercanas con elementos del mundo mediante `Area2D`. Ver [InteractionSystem/README.md](InteractionSystem/README.md).
- **StateMachine / State**: Máquina de estados jerárquica simple para nodos. Ver [StateMachine.md](StateMachine.md).
- **SceneManager**: Cambio de escenas con transiciones opcionales y bloqueo de entrada. Ver [SceneManager/README.md](SceneManager/README.md).
- **GameFlow**: Autoload que centraliza el estado global del juego y notifica cambios con la señal `state_changed`. Ver [GameFlow.md](GameFlow.md).
- **EventBus**: Autoload para comunicación desacoplada mediante señales compartidas entre sistemas. Ver [EventBus.md](EventBus.md).

---

# Project base systems (English)

This directory includes reusable templates for common Godot systems. Each bullet summarizes the purpose of the files and links to detailed instructions inside the corresponding subdirectories.

- **SaveSystem / SaveData**: Game save/load using `.tres` resources. See [SaveSystem.md](SaveSystem.md).
- **StaticDataParser**: Utility for reading static data from JSON files. Documented in [SaveSystem.md](SaveSystem.md) because it usually feeds inventories or other persistent systems.
- **Inventory**: Stackable item handling with an item database and update signal. See [Inventory/README.md](Inventory/README.md).
- **InteractionSystem**: Proximity interactions with world elements via `Area2D`. See [InteractionSystem/README.md](InteractionSystem/README.md).
- **StateMachine / State**: Simple hierarchical state machine for nodes. See [StateMachine.md](StateMachine.md).
- **SceneManager**: Scene swapping with optional transitions and input blocking. See [SceneManager/README.md](SceneManager/README.md).
- **GameFlow**: Autoload that centralizes the global game state and notifies changes through the `state_changed` signal. See [GameFlow.md](GameFlow.md).
- **EventBus**: Autoload for decoupled communication through shared signals between systems. See [EventBus.md](EventBus.md).
