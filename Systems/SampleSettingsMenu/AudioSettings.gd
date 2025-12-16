extends Control

@export var slider_step: float = 0.05

@export var _master_slider: HSlider
@export var _music_slider: HSlider
@export var _sfx_slider: HSlider
@export var _ui_slider: HSlider
@export var _master_value_label: Label
@export var _music_value_label: Label
@export var _sfx_value_label: Label
@export var _ui_value_label: Label

func _ready() -> void:
	_configure_sliders()
	_connect_signals()

func _configure_sliders() -> void:
	_configure_slider(_master_slider, _master_value_label, _get_bus_volume("Master"))
	_configure_slider(_music_slider, _music_value_label, _get_bus_volume("Music"))
	_configure_slider(_sfx_slider, _sfx_value_label, _get_bus_volume("SFX"))
	_configure_slider(_ui_slider, _ui_value_label, _get_bus_volume("UI"))

func _configure_slider(slider: HSlider, value_label: Label, initial_value: float) -> void:
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.step = slider_step
	slider.value = clamp(initial_value, slider.min_value, slider.max_value)
	_update_value_label(value_label, slider.value)

func _connect_signals() -> void:
	_master_slider.value_changed.connect(_on_master_volume_changed)
	_music_slider.value_changed.connect(_on_music_volume_changed)
	_sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	_ui_slider.value_changed.connect(_on_ui_volume_changed)

func _on_master_volume_changed(value: float) -> void:
	_update_value_label(_master_value_label, value)
	_apply_volume(AudioManager.set_master_volume, value)

func _on_music_volume_changed(value: float) -> void:
	_update_value_label(_music_value_label, value)
	_apply_volume(AudioManager.set_music_volume, value)

func _on_sfx_volume_changed(value: float) -> void:
	_update_value_label(_sfx_value_label, value)
	_apply_volume(AudioManager.set_sfx_volume, value)

func _on_ui_volume_changed(value: float) -> void:
	_update_value_label(_ui_value_label, value)
	_apply_volume(AudioManager.set_ui_volume, value)

func _apply_volume(setter: Callable, value: float) -> void:
	if has_node("/root/AudioManager"):
		setter.call(value)
	else:
		push_warning("AudioManager autoload not found; volume change skipped.")

func _update_value_label(label: Label, value: float) -> void:
	label.text = str(round(int(value * 100)))

func _get_bus_volume(bus_name: String) -> float:
	var bus := AudioServer.get_bus_index(bus_name)
	if bus == -1:
		push_warning("Audio bus not found: " + bus_name)
		return 1.0

	return clamp(db_to_linear(AudioServer.get_bus_volume_db(bus)), 0.0, 1.0)
