extends Node
class_name SceneManager

signal scene_loaded(scene: Node)

var current_scene: Node = null
var transition: SceneTransition


func _ready() -> void:
	var t := get_node_or_null("/root/SceneTransition")
	if t is SceneTransition:
		transition = t
	else:
		push_warning("SceneManager: No SceneTransition found. Transitions disabled.")

func change_scene(
		scene_path: String,
		use_transition: bool = false,
		fade_out_time: float = 0.8,
		fade_in_time: float = 0.8,
		custom_background: Texture2D = null
	) -> void:

	if use_transition and transition != null:
		await transition.fade_out(fade_out_time, custom_background)

	if current_scene != null:
		current_scene.queue_free()
		await get_tree().process_frame

	var packed: PackedScene = load(scene_path)
	if packed == null:
		push_error("SceneManager ERROR: Could not load scene: %s" % scene_path)
		return

	current_scene = packed.instantiate()
	get_tree().root.add_child(current_scene)

	emit_signal("scene_loaded", current_scene)

	if use_transition and transition != null:
		await get_tree().process_frame
		await transition.fade_in(fade_in_time)
