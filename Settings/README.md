# Settings Menu

Interfaz de ajustes lista para añadir a cualquier escena. El menú se organiza en dos pestañas (Video y Audio) y se apoya en los sistemas base del repositorio.

## Estructura
- **SettingsMenu.tscn**: escena principal con un `TabContainer` que agrupa las pestañas de Video y Audio.
- **VideoSettings.gd**: script de la pestaña de Video. Gestiona resoluciones y modo de pantalla completa.
- **AudioSettings.gd**: script de la pestaña de Audio. Controla el volumen de los buses usando `AudioManager`.

## Integración
1. Instancia `Settings/SettingsMenu.tscn` en tu escena (por ejemplo, dentro de un menú de opciones).
2. Asegúrate de que los autoloads del proyecto incluyan `AudioManager` (ya configurado en `project.godot`).
3. Crea los buses `Music`, `SFX` y `UI` bajo `Master` en el *Audio Bus Layout* para que los sliders funcionen.

## Comportamiento
- **Video**
  - Lista de resoluciones filtrada para no mostrar tamaños superiores al de la pantalla actual.
  - Al cambiar la resolución, la ventana se centra automáticamente.
  - El toggle de pantalla completa ajusta el modo del `Window` y fuerza el tamaño al de la pantalla activa.
- **Audio**
  - Cuatro sliders (Master, Música, SFX, UI) conectados a la API pública de `AudioManager`.
  - Los valores iniciales de cada slider se leen del volumen real de cada bus.
