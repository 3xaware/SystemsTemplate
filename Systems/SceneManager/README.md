# SceneManager (español)

Sistema para cargar y cambiar escenas de Godot con soporte opcional para transiciones de fundido y bloqueo de entrada mientras se realiza el cambio.

## Componentes
- **SceneManager.gd** (`Node`): nodo orquestador que instancia nuevas escenas, destruye la anterior y emite `scene_loaded(scene: Node)` cuando finaliza el cambio.
- **SceneTransition.gd** (`CanvasLayer`): capa visual para fundidos de entrada/salida que también bloquea la entrada mientras anima.
- **InputBlocker.gd** (`Node`): utilitario global que consume eventos de entrada cuando `block_input()` está activo.
- **SceneTransition.tscn**: escena que contiene un `ColorRect` para cubrir la pantalla durante los fundidos. Debe añadirse al árbol como autoload o hijo de la raíz.

## Configuración
1. **Añadir SceneManager**
   - Agrega un nodo con el script `SceneManager.gd` a la escena raíz o como autoload para que esté disponible en todo momento.
   - Conecta la señal `scene_loaded` si necesitas ejecutar lógica justo después de que una escena termine de instanciarse.
2. **Configurar transiciones (opcional)**
   - Instancia `SceneTransition.tscn` y colócala en `/root/SceneTransition` (autoload recomendado). El `SceneManager` la buscará en esa ruta.
   - Añade `InputBlocker.gd` como autoload para que la transición pueda bloquear la entrada durante la animación.

## Uso
- **Cambio básico sin transición**
  ```gdscript
  $SceneManager.change_scene("res://Scenes/Menu.tscn")
  ```
- **Cambio con fundido y fondo personalizado**
  ```gdscript
  var bg: Texture2D = load("res://UI/FadeTexture.png")
  $SceneManager.change_scene(
          "res://Scenes/Level1.tscn",
          use_transition = true,
          fade_out_time = 0.6,
          fade_in_time = 0.4,
          custom_background = bg
  )
  ```
- **Responder al evento de carga**
  ```gdscript
  func _ready():
          $SceneManager.scene_loaded.connect(_on_scene_loaded)

  func _on_scene_loaded(scene: Node) -> void:
          print("Nueva escena lista: ", scene.name)
  ```

## Flujo interno
1. Si se solicita transición y existe `SceneTransition`, se ejecuta `fade_out`, que muestra el `ColorRect`, bloquea la entrada y anima la opacidad hasta 1.
2. La escena actual se libera con `queue_free()` y se espera un frame para limpiar nodos.
3. Se carga el `PackedScene` solicitado; si falla, se registra un error y no se continúa.
4. Se instancia la nueva escena, se añade al árbol raíz y se emite la señal `scene_loaded`.
5. Si había transición, se espera un frame y luego se realiza `fade_in`, que oculta el `ColorRect`, desbloquea la entrada y marca el final de la animación.

## Buenas prácticas
- Mantén `SceneTransition` como autoload para que siempre esté disponible y no tengas que añadirlo manualmente en cada escena.
- Usa transiciones al mover al jugador entre escenas de juego para evitar que reciba entrada mientras se cargan nodos.
- Valida las rutas de escena que envías a `change_scene` para evitar errores en tiempo de ejecución.

---

# SceneManager (English)

System to load and swap Godot scenes with optional fade transitions and input blocking while the change happens.

## Components
- **SceneManager.gd** (`Node`): orchestrator node that instantiates new scenes, frees the previous one, and emits `scene_loaded(scene: Node)` when the swap finishes.
- **SceneTransition.gd** (`CanvasLayer`): visual layer for fade in/out effects that also blocks input while animating.
- **InputBlocker.gd** (`Node`): global utility that consumes input events when `block_input()` is active.
- **SceneTransition.tscn**: scene containing a `ColorRect` to cover the screen during fades. Should be added to the tree as an autoload or child of the root.

## Setup
1. **Add SceneManager**
   - Add a node with the `SceneManager.gd` script to the root scene or as an autoload so it is always available.
   - Connect the `scene_loaded` signal if you need to run logic right after a scene finishes instantiating.
2. **Configure transitions (optional)**
   - Instance `SceneTransition.tscn` and place it at `/root/SceneTransition` (autoload recommended). `SceneManager` will look for it at that path.
   - Add `InputBlocker.gd` as an autoload so the transition can block input during the animation.

## Usage
- **Basic change without transition**
  ```gdscript
  $SceneManager.change_scene("res://Scenes/Menu.tscn")
  ```
- **Change with fade and custom background**
  ```gdscript
  var bg: Texture2D = load("res://UI/FadeTexture.png")
  $SceneManager.change_scene(
          "res://Scenes/Level1.tscn",
          use_transition = true,
          fade_out_time = 0.6,
          fade_in_time = 0.4,
          custom_background = bg
  )
  ```
- **React to the load event**
  ```gdscript
  func _ready():
          $SceneManager.scene_loaded.connect(_on_scene_loaded)

  func _on_scene_loaded(scene: Node) -> void:
          print("New scene ready: ", scene.name)
  ```

## Internal flow
1. If transition is requested and `SceneTransition` exists, `fade_out` runs: it shows the `ColorRect`, blocks input, and animates opacity to 1.
2. The current scene is freed via `queue_free()` and one frame is awaited to clean nodes.
3. The requested `PackedScene` is loaded; if loading fails, an error is logged and the process stops.
4. The new scene is instantiated, added to the root, and the `scene_loaded` signal is emitted.
5. If a transition was used, the manager waits one frame and performs `fade_in`, which hides the `ColorRect`, unblocks input, and marks the end of the animation.

## Best practices
- Keep `SceneTransition` as an autoload so it is always available and you don't need to add it manually in every scene.
- Use transitions when moving the player between gameplay scenes to prevent input while nodes load.
- Validate scene paths you pass to `change_scene` to avoid runtime errors.
