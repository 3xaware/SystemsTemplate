# Máquina de estados (Español)

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

---

# State machine (English)

Implements a simple state flow for nodes, with explicit transitions by name.

## Components
- **State.gd** (`Node`): base class for specific states. Exposes methods to override:
  - `Enter()`, `Exit()`, `OnInput(event)`, `Update(delta)`, `Physics_Update(delta)`.
  - Signal `state_transition` to request changes.
  - `parent` property is filled with the parent node assigned by the machine.
- **StateMachine.gd** (`Node`): orchestrator that manages child states.
  - `initial_state` (exported) indicates the startup state.
  - Dictionary `states` indexed by the node name in lowercase.

## Setup
1. **Scene structure**
   - Create a `StateMachine` node and add children that extend `State`. Put each behaviour in its script derived from `State`.
   - Assign `initial_state` from the Inspector to the starting state node.
2. **Initialization**
   - Call `StateMachine.init(parent_node)` from the node that owns the machine (for example, in the player's `_ready()`). This:
         - Assigns `parent` to every state.
		 - Connects each state's `state_transition` signal to `change_state`.
		 - Runs `Enter()` on the `initial_state`.

## In-game usage
- `StateMachine` forwards `_input`, `_process`, and `_physics_process` to the active state so you keep logic there.
- To switch states from a concrete state, emit the signal with the new state's name:
  ```gdscript
  # Inside a child state
  func Update(delta):
          if should_jump():
                  state_transition.emit(self, "jump")
  ```
  The name must match the destination state's node name (case-insensitive).

## Recommendations
- Ensure `init` is called before input events arrive; otherwise `_process` will warn that the machine was not initialized.
- Place specific logic inside the state methods instead of using conditionals in the machine.
- When calling `change_state`, avoid emitting the transition from a state that is not the current one; the machine will validate and discard it to prevent logical errors.
