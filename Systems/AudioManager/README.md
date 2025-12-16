# AudioManager (Español)

Este sistema centraliza toda la reproducción de audio del proyecto mediante un `AudioManager` y un backend configurable.
Incluye los puntos de entrada públicos (`play_music`, `play_sfx`, `play_ui`, etc.), control de pausa según el estado del juego
(y el autoload `GameFlow`), y ajustes de volumen por buses.

## Estructura y escena
- **AudioManager.tscn**: escena autoload que contiene un nodo `AudioManager` (script `AudioManager.gd`) con un hijo
  `GodotAudioBackend` (script `GodotAudioBackend.gd`).
- **AudioBackend.gd**: interfaz base para backends de audio. Si necesitas integrar otro motor de audio, implementa aquí las
  funciones abstractas.
- **GodotAudioBackend.gd**: implementación actual que usa `AudioStreamPlayer` y los buses de Godot.

## Pasos para integrarlo en un proyecto
1. **Añade la escena como autoload**:
   - Abre *Proyecto ▸ Configuración del proyecto ▸ AutoLoad*.
   - Selecciona `AudioManager.tscn`, usa el nombre `AudioManager` y presiona *Agregar*.
2. **Configura los Audio Buses**:
   - En el *Audio Bus Layout* crea (o verifica) los buses `Music`, `SFX` y `UI` como hijos de `Master`.
   - Ajusta los efectos o rutas según tu mezcla; el backend escribe en esos buses y controla su volumen.
   **Nota importante**  
   Crear un Audio Bus Layout no es suficiente: el layout debe estar **asignado como activo** para que el motor lo use en runtime.

   Para hacerlo:
   1. Abre *Proyecto ▸ Configuración del proyecto*.
   2. Ve a *Audio ▸ Buses*.
   3. En el campo **Bus Layout**, selecciona explícitamente tu archivo de layout (por ejemplo `audio_bus.tres`).
   4. Guarda el proyecto y reinicia el editor para asegurar que los buses estén disponibles en ejecución.
3. **Instancia `GameFlow` si se usa pausa automática**:
   - El `AudioManager` escucha `GameFlow.state_changed` para pausar/reanudar música y efectos durante `PAUSED`/`GAMEPLAY`.
   - Si no usas `GameFlow`, puedes eliminar la conexión en `_ready` o implementar señales equivalentes.

## Registrar y conectar los archivos de audio
Los diccionarios de audio se configuran desde el inspector del nodo `GodotAudioBackend` dentro de `AudioManager.tscn`:

- **music_library**: IDs de música ➜ `AudioStream` importados. Ejemplo: `"main_theme" : res://audio/music/main_theme.ogg`.
- **sfx_library**: IDs de efectos ➜ `AudioStream`. Ejemplo: `"jump" : res://audio/sfx/jump.wav`.
- **ui_library**: IDs de interfaz ➜ `AudioStream`. Ejemplo: `"menu_click" : res://audio/ui/click.ogg`.
- **sfx_pool_size**: tamaño de la piscina de reproductores de SFX simultáneos (al menos 1). Si todos están ocupados, el backend
  recicla el reproductor menos usado.

Recomendaciones:
- Usa nombres de ID descriptivos y únicos; estos IDs son las claves que el gameplay debe pasar a la API pública.
- No uses rutas como ID. Las rutas se asignan a los IDs en los diccionarios; el código solo debe conocer el ID.
- Asegúrate de que los archivos estén importados como `AudioStream` en el proyecto antes de asignarlos.

## Uso en código
Con el autoload activo puedes llamar a `AudioManager` desde cualquier script:

```gdscript
AudioManager.play_music("main_theme")
AudioManager.play_sfx("jump")
AudioManager.play_ui("menu_click")
AudioManager.stop_music()

AudioManager.set_master_volume(0.8) # 0.0 a 1.0
AudioManager.set_music_volume(0.6)
```

## Comportamiento de pausa y reanudación
- Al recibir `GameFlow.State.PAUSED` se pausarán música y SFX (`stream_paused = true`).
- Al volver a `GameFlow.State.GAMEPLAY` se reanudan.
- Si necesitas pausar absolutamente todo (incluida la UI) llama a `GodotAudioBackend.pause_all_audio()` desde código o extiende
  el `AudioManager` con un método público que delegue en el backend.

## Extender o sustituir el backend
Si integras otro sistema de audio:
1. Crea un nuevo script que extienda `AudioBackend.gd` y complete los métodos.
2. Sustituye el nodo `GodotAudioBackend` en la escena por tu implementación y asigna el nuevo script.
3. Respeta los nombres de ID y la API pública de `AudioManager` para mantener compatibilidad con el gameplay.

---

# AudioManager (English)

This system centralizes all audio playback through an `AudioManager` node and a configurable backend. It exposes public entry
points (`play_music`, `play_sfx`, `play_ui`, etc.), reacts to the global game state via `GameFlow`, and adjusts volumes through
Godot audio buses.

## Structure and scene
- **AudioManager.tscn**: autoload scene with an `AudioManager` node (`AudioManager.gd`) and a `GodotAudioBackend` child
  (`GodotAudioBackend.gd`).
- **AudioBackend.gd**: base interface for audio backends. Implement it if you plug in a different audio engine.
- **GodotAudioBackend.gd**: current implementation using `AudioStreamPlayer` nodes and Godot buses.

## Steps to add it to a project
1. **Add the scene as an autoload**:
   - Open *Project ▸ Project Settings ▸ AutoLoad*.
   - Select `AudioManager.tscn`, set the name to `AudioManager`, and click *Add*.
2. **Configure Audio Buses**:
   - In the *Audio Bus Layout* create (or verify) the `Music`, `SFX`, and `UI` buses under `Master`.
   - Tweak effects or routing as needed; the backend writes to these buses and controls their volumes.
   **Important note**  
   Creating an Audio Bus Layout is not enough: the layout must be **explicitly assigned** to be used at runtime.

   To do this:
   1. Open *Project ▸ Project Settings*.
   2. Go to *Audio ▸ Buses*.
   3. In the **Bus Layout** field, explicitly select your layout file (for example `audio_bus.tres`).
   4. Save the project and restart the editor to ensure the buses are active at runtime.
3. **Instantiate `GameFlow` if you want automatic pause handling**:
   - `AudioManager` listens to `GameFlow.state_changed` to pause/resume music and SFX on `PAUSED`/`GAMEPLAY`.
   - If you do not use `GameFlow`, remove the connection in `_ready` or emit equivalent signals.

## Registering and wiring audio files
Set up the dictionaries from the inspector on the `GodotAudioBackend` node inside `AudioManager.tscn`:

- **music_library**: music IDs ➜ imported `AudioStream` resources. Example: `"main_theme" : res://audio/music/main_theme.ogg`.
- **sfx_library**: SFX IDs ➜ `AudioStream`. Example: `"jump" : res://audio/sfx/jump.wav`.
- **ui_library**: UI IDs ➜ `AudioStream`. Example: `"menu_click" : res://audio/ui/click.ogg`.
- **sfx_pool_size**: pool size of simultaneous SFX players (minimum 1). If all are busy, the backend recycles the least-recently
  used player.

Recommendations:
- Use clear, unique IDs; those keys are what gameplay code passes into the public API.
- Do not use file paths as IDs. Paths are assigned to IDs inside the dictionaries; gameplay should only know the ID.
- Ensure the files are imported as `AudioStream` resources before assigning them.

## Usage in code
Once autoloaded you can invoke `AudioManager` from any script:

```gdscript
AudioManager.play_music("main_theme")
AudioManager.play_sfx("jump")
AudioManager.play_ui("menu_click")
AudioManager.stop_music()

AudioManager.set_master_volume(0.8) # 0.0 to 1.0
AudioManager.set_music_volume(0.6)
```

## Pause/resume behavior
- When `GameFlow.State.PAUSED` is received, music and SFX are paused (`stream_paused = true`).
- Returning to `GameFlow.State.GAMEPLAY` resumes them.
- If you need to pause absolutely everything (including UI) call `GodotAudioBackend.pause_all_audio()` from code or extend the
  `AudioManager` with a public method that delegates to the backend.

## Extending or replacing the backend
To integrate another audio system:
1. Create a new script extending `AudioBackend.gd` and implement the methods.
2. Replace the `GodotAudioBackend` node in the scene with your implementation and assign the new script.
3. Keep the ID names and the `AudioManager` public API to stay compatible with gameplay code.
