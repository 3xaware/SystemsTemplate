# Sistemas base del proyecto (Español)

Este directorio contiene plantillas reutilizables para sistemas habituales en Godot. Cada sección resume el propósito de los archivos y enlaza a instrucciones más detalladas en los subdirectorios correspondientes.

- **SaveSystem / SaveData**: Guardado y carga de datos del juego mediante recursos `.tres`. Consulta [SaveSystem/README.md](SaveSystem/README.md).
- **StaticDataParser**: Utilidad para leer datos estáticos desde archivos JSON. Se documenta en [SaveSystem/README.md](SaveSystem/README.md) porque suele alimentar inventarios u otros sistemas persistentes.
- **Inventory**: Gestión de ítems apilables, con base de datos de ítems y señal de actualización. Ver [Inventory/README.md](Inventory/README.md).
- **InteractionSystem**: Interacciones cercanas con elementos del mundo mediante `Area2D`. Ver [InteractionSystem/README.md](InteractionSystem/README.md).
- **StateMachine / State**: Máquina de estados jerárquica simple para nodos. Ver [StateMachine.md](StateMachine.md).
- **SceneManager**: Cambio de escenas con transiciones opcionales y bloqueo de entrada. Ver [SceneManager/README.md](SceneManager/README.md).
- **GameFlow**: Autoload que centraliza el estado global del juego y notifica cambios con la señal `state_changed`. Ver [GameFlow.md](GameFlow.md).
- **EventBus**: Autoload para comunicación desacoplada mediante señales compartidas entre sistemas. Ver [EventBus.md](EventBus.md).
- **AudioManager**: Reproducción centralizada de música, SFX y audio de UI mediante un backend configurable. Ver [AudioManager/README.md](AudioManager/README.md).
- **SampleSettingsMenu**: Escena de ejemplo (`SampleSettingsMenu/SettingsMenu.tscn`) con scripts de audio y video que ilustran cómo conectar sliders y botones a `AudioManager` y a tu propia lógica de configuración.

## Configuración general recomendada
1. **Autoloads base**: registra `EventBus.gd`, `GameFlow.gd`, `SceneManager.gd`, `AudioManager.tscn` y `SaveSystem.gd` en *Proyecto ▸ Configuración del proyecto ▸ AutoLoad* para que los sistemas estén siempre disponibles.
2. **Transiciones e input**: añade `SceneTransition.tscn` y `InputBlocker.gd` como autoloads si usarás fundidos al cambiar de escena.
3. **Buses de audio**: crea en el *Audio Bus Layout* los buses `Music`, `SFX` y `UI` como hijos de `Master` para que el `AudioManager` pueda enrutar el audio.
4. **Señales globales**: conecta los sistemas a `EventBus` según su documentación (por ejemplo, `SceneManager` emite `scene_loaded` y `GameFlow` expone `state_changed`) para mantener el acoplamiento desacoplado.
5. **Datos persistentes**: si usas guardado, inicializa `SaveSystem` al arrancar y conecta tu HUD o sistemas interesados a las señales `save_loaded` y `save_saved` del `EventBus`.

El menú de ajustes de ejemplo (`SampleSettingsMenu/SettingsMenu.tscn`) trae `AudioSettings.gd` y `VideoSettings.gd`; al instanciarlo puedes reutilizar los sliders exportados que ya invocan a `AudioManager` para modificar los buses `Master`, `Music`, `SFX` y `UI`, o reemplazar las llamadas si tienes otra lógica de configuración.

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
- **AudioManager**: Centralized playback for music, SFX, and UI audio through a configurable backend. See [AudioManager/README.md](AudioManager/README.md).
- **SampleSettingsMenu**: Example scene (`SampleSettingsMenu/SettingsMenu.tscn`) with audio and video scripts that demonstrate wiring sliders and buttons to `AudioManager` and to your own settings logic.

## Recommended project-wide setup
1. **Core autoloads**: register `EventBus.gd`, `GameFlow.gd`, `SceneManager.gd`, `AudioManager.tscn`, and `SaveSystem.gd` under *Project ▸ Project Settings ▸ AutoLoad* so the systems are always available.
2. **Transitions and input**: add `SceneTransition.tscn` and `InputBlocker.gd` as autoloads if you plan to use fades during scene changes.
3. **Audio buses**: create `Music`, `SFX`, and `UI` buses under `Master` in the *Audio Bus Layout* so `AudioManager` can route audio properly.
4. **Global signals**: wire systems to `EventBus` as documented (for example, `SceneManager` emits `scene_loaded` and `GameFlow` exposes `state_changed`) to keep communication decoupled.
5. **Persistence**: if you use saving, initialize `SaveSystem` on startup and hook your HUD or interested systems to the `save_loaded` and `save_saved` signals on the `EventBus`.

The sample settings menu (`SampleSettingsMenu/SettingsMenu.tscn`) ships with `AudioSettings.gd` and `VideoSettings.gd`; once instanced you can reuse the exported sliders that already call `AudioManager` to adjust the `Master`, `Music`, `SFX`, and `UI` buses or swap the calls for your own settings logic.
