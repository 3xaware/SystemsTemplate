# Sistemas base del proyecto

Este directorio contiene plantillas reutilizables para sistemas habituales en Godot. Cada sección resume el propósito de los archivos y enlaza a instrucciones más detalladas en los subdirectorios correspondientes.

- **SaveSystem / SaveData**: Guardado y carga de datos del juego mediante recursos `.tres`. Consulta [SaveSystem.md](SaveSystem.md).
- **StaticDataParser**: Utilidad para leer datos estáticos desde archivos JSON. Se documenta en [SaveSystem.md](SaveSystem.md) porque suele alimentar inventarios u otros sistemas persistentes.
- **Inventory**: Gestión de ítems apilables, con base de datos de ítems y señal de actualización. Ver [Inventory/README.md](Inventory/README.md).
- **InteractionSystem**: Interacciones cercanas con elementos del mundo mediante `Area2D`. Ver [InteractionSystem/README.md](InteractionSystem/README.md).
- **StateMachine / State**: Máquina de estados jerárquica simple para nodos. Ver [StateMachine.md](StateMachine.md).
