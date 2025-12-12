# Máquina de estados

Implementa un flujo simple de estados para nodos, con transición explícita por nombre.

## Componentes
- **State.gd** (`Node`): clase base para estados específicos. Expone métodos a sobreescribir:
  - `Enter()`, `Exit()`, `OnInput(event)`, `Update(delta)`, `Physics_Update(delta)`.
  - Señal `state_transition` para solicitar cambios.
  - Propiedad `parent` se rellena con el nodo padre asignado por la máquina.
- **StateMachine.gd** (`Node`): orquestador que gestiona estados hijos.
  - `initial_state` (exportado) indica el estado de arranque.
  - Diccionario `states` indexado por el nombre del nodo en minúsculas.

## Configuración
1. **Estructura en la escena**
   - Crea un nodo `StateMachine` y agrégale como hijos nodos que extiendan `State`. Coloca cada comportamiento en su script derivado de `State`.
   - Asigna `initial_state` desde el Inspector al nodo de estado inicial.
2. **Inicialización**
   - Llama a `StateMachine.init(parent_node)` desde el nodo que posee la máquina (por ejemplo, en `_ready()` del jugador). Esto:
     - Asigna `parent` a cada estado.
     - Conecta la señal `state_transition` de cada estado a `change_state`.
     - Ejecuta `Enter()` del `initial_state`.

## Uso durante el juego
- `StateMachine` reenvía `_input`, `_process` y `_physics_process` al estado activo para que concentres la lógica allí.
- Para cambiar de estado desde un estado concreto, emite la señal con el nombre del nuevo estado:
  ```gdscript
  # Dentro de un estado hijo
  func Update(delta):
      if should_jump():
          state_transition.emit(self, "jump")
  ```
  El nombre debe coincidir con el nodo del estado destino (sin distinción de mayúsculas/minúsculas).

## Recomendaciones
- Asegúrate de que `init` se llama antes de que lleguen eventos de entrada; de lo contrario, `_process` avisará que la máquina no se inicializó.
- Coloca la lógica específica en los métodos del estado en vez de usar condicionales en la máquina.
- Cuando hagas `change_state`, evita emitir la transición desde un estado que no sea el actual; la máquina lo validará y lo descartará para prevenir errores lógicos.
