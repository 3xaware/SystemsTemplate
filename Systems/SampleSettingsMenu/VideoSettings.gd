extends Control

@export var available_resolutions: Array[Vector2i] = [
	Vector2i(1920, 1080),
	Vector2i(1600, 900),
	Vector2i(1366, 768),
	Vector2i(1280, 720)
]

@export var _resolution_option: OptionButton
@export var _fullscreen_toggle: CheckButton

func _ready() -> void:
	_populate_resolutions()
	_sync_with_window()
	_resolution_option.item_selected.connect(_on_resolution_selected)
	_fullscreen_toggle.toggled.connect(_on_fullscreen_toggled)

func _populate_resolutions() -> void:
	var screen := DisplayServer.window_get_current_screen()
	var screen_size: Vector2i = DisplayServer.screen_get_size(screen)
	_resolution_option.clear()

	var resolutions: Array[Vector2i] = []
	for resolution in available_resolutions:
		if resolution.x <= screen_size.x and resolution.y <= screen_size.y and not resolutions.has(resolution):
			resolutions.append(resolution)

	var current_size: Vector2i = get_window().size
	if current_size.x <= screen_size.x and current_size.y <= screen_size.y and not resolutions.has(current_size):
		resolutions.append(current_size)

	resolutions.sort_custom(func(a: Vector2i, b: Vector2i) -> bool:
		return a.y > b.y if a.x == b.x else a.x > b.x
	)

	for resolution in resolutions:
		var label := str(resolution.x) + "x" + str(resolution.y)
		_resolution_option.add_item(label)
		_resolution_option.set_item_metadata(_resolution_option.item_count - 1, resolution)

func _sync_with_window() -> void:
	var window := get_window()
	_fullscreen_toggle.button_pressed = window.mode == Window.MODE_FULLSCREEN

	var current_size: Vector2i = window.size
	var index := _find_resolution_index(current_size)
	if index == -1 and _resolution_option.item_count > 0:
		index = 0

	if index != -1:
		_resolution_option.select(index)

func _find_resolution_index(target: Vector2i) -> int:
	for i in _resolution_option.item_count:
		var resolution: Vector2i = _resolution_option.get_item_metadata(i)
		if resolution == target:
			return i
	return -1

func _on_resolution_selected(index: int) -> void:
	var resolution: Vector2i = _resolution_option.get_item_metadata(index)
	_apply_resolution(resolution)

func _on_fullscreen_toggled(pressed: bool) -> void:
	var window := get_window()
	if pressed:
		window.mode = Window.MODE_FULLSCREEN
		var screen_size: Vector2i = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
		window.size = screen_size
	else:
		window.mode = Window.MODE_WINDOWED
		var resolution := _get_selected_resolution()
		if resolution != Vector2i.ZERO:
			_apply_resolution(resolution)

	_center_window()

func _apply_resolution(resolution: Vector2i) -> void:
	var screen_size: Vector2i = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
	if resolution.x > screen_size.x or resolution.y > screen_size.y:
		push_warning("Resolution exceeds screen size and will be ignored.")
		return

	var window := get_window()
	window.mode = Window.MODE_WINDOWED
	window.size = resolution
	_center_window()

func _get_selected_resolution() -> Vector2i:
	var selected := _resolution_option.get_selected()
	if selected < 0:
		return Vector2i.ZERO
	return _resolution_option.get_item_metadata(selected)

func _center_window() -> void:
	var window := get_window()
	var window_id := window.get_window_id()
	var screen := DisplayServer.window_get_current_screen(window_id)
	var screen_size: Vector2i = DisplayServer.screen_get_size(screen)
	var centered := Vector2i(
		(screen_size.x - window.size.x) / 2,
		(screen_size.y - window.size.y) / 2
	)
	DisplayServer.window_set_position(centered, window_id)
