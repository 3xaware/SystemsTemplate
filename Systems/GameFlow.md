# Flujo de juego (Español)

`GameFlow.gd` es un autoload minimalista que centraliza el **estado global del juego** mediante un enum (`BOOT`, `MAIN_MENU`, `LOADING`, `GAMEPLAY`, `PAUSED`) y una señal `state_changed`. Otros sistemas se suscriben a esta señal para actualizar UI, bloquear controles o iniciar lógicas específicas según el estado.

## Cómo funciona
- Al iniciarse, fija el estado en `BOOT` y se conecta al `EventBus`.
- Cuando `EventBus.save_loaded` se emite, pasa a `LOADING` mientras se reconstruye la partida.
- El método público `set_state()` permite forzar otros estados (por ejemplo, `MAIN_MENU` o `PAUSED`).

## API rápida
- `set_state(new_state: GameFlow.State)`
  - Cambia el estado y emite `state_changed(previous, current)` si es distinto del actual.
- `get_state() -> GameFlow.State`
  - Devuelve el estado actual.
- `is_state(state: GameFlow.State) -> bool`
  - Atajo para comparar con el estado actual.
- `is_gameplay() -> bool` / `is_paused() -> bool`
  - Consultas frecuentes para decidir si se permiten entradas o se debe mostrar la UI de pausa.

## Integración con otros sistemas y el juego
- **SceneManager**: tras cargar una escena, decide el estado que corresponda (por ejemplo, `MAIN_MENU` para menús o `GAMEPLAY` para niveles) y lo fija con `GameFlow.set_state`.
- **SaveSystem**: al terminar de cargar una ranura se emite `EventBus.save_loaded` y `GameFlow` marca `LOADING` hasta que la escena notifique que está lista.
- **UI/Controles**: escucha `state_changed` para mostrar el menú principal (`MAIN_MENU`), bloquear inputs durante `LOADING` o desplegar la pantalla de pausa (`PAUSED`).
- **Lógica de juego**: otros nodos pueden consultar `GameFlow.is_gameplay()` antes de procesar físicas o spawns.

## Uso típico
1. Marca `GameFlow` como autoload.
2. En cada sistema que dependa del estado global, conéctate a la señal:
```gdscript
GameFlow.state_changed.connect(_on_game_state_changed)
```
3. Ajusta UI o controles según el estado recibido:
```gdscript
func _on_game_state_changed(previous: GameFlow.State, current: GameFlow.State) -> void:
	match current:
		GameFlow.State.MAIN_MENU:
			_show_main_menu()
		GameFlow.State.LOADING:
			_block_input()
		GameFlow.State.PAUSED:
			_show_pause_menu()
		GameFlow.State.GAMEPLAY:
			_resume_gameplay()
```
4. Si necesitas cambiar manualmente el flujo (por ejemplo, al abrir el menú principal):
```gdscript
GameFlow.set_state(GameFlow.State.MAIN_MENU)
```

---

# Game flow (English)

`GameFlow.gd` is a lightweight autoload that centralizes the **global game state** via an enum (`BOOT`, `MAIN_MENU`, `LOADING`, `GAMEPLAY`, `PAUSED`) and a `state_changed` signal. Other systems subscribe to this signal to update UI, lock controls, or trigger behaviors based on the current state.

## How it works
- On startup it sets the state to `BOOT` and connects to `EventBus`.
- When `EventBus.save_loaded` fires, it switches to `LOADING` while the save is being reconstructed.
- The public `set_state()` method lets you force other states (for example `MAIN_MENU` or `PAUSED`).

## Quick API
- `set_state(new_state: GameFlow.State)`
  - Changes the state and emits `state_changed(previous, current)` if it differs from the current one.
- `get_state() -> GameFlow.State`
  - Returns the current state.
- `is_state(state: GameFlow.State) -> bool`
  - Shortcut to compare against the current state.
- `is_gameplay() -> bool` / `is_paused() -> bool`
  - Common queries to decide if input should be allowed or the pause UI should be shown.

## Integration with other systems and the game
- **SceneManager**: after loading a scene, decide the appropriate state (for example `MAIN_MENU` for menus or `GAMEPLAY` for levels) and set it via `GameFlow.set_state`.
- **SaveSystem**: once a slot finishes loading, `EventBus.save_loaded` is emitted and `GameFlow` marks `LOADING` until the scene reports readiness.
- **UI/Controls**: listen to `state_changed` to show the main menu (`MAIN_MENU`), block input during `LOADING`, or display the pause screen (`PAUSED`).
- **Game logic**: other nodes can call `GameFlow.is_gameplay()` before running physics or spawning entities.

## Typical usage
1. Keep `GameFlow` as an autoload.
2. In each system that depends on the global state, connect to the signal:
   ```gdscript
   GameFlow.state_changed.connect(_on_game_state_changed)
   ```
3. Adjust UI or controls based on the received state:
```gdscript
func _on_game_state_changed(previous: GameFlow.State, current: GameFlow.State) -> void:
	match current:
		GameFlow.State.MAIN_MENU:
			_show_main_menu()
		GameFlow.State.LOADING:
			_block_input()
		GameFlow.State.PAUSED:
			_show_pause_menu()
		GameFlow.State.GAMEPLAY:
			_resume_gameplay()
```
4. If you need to manually change the flow (for example when opening the main menu):
```gdscript
GameFlow.set_state(GameFlow.State.MAIN_MENU)
```
