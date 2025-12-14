extends AudioBackend
class_name GodotAudioBackend

@export var music_library: Dictionary = {}
@export var sfx_library: Dictionary = {}
@export var ui_library: Dictionary = {}

var _music_player: AudioStreamPlayer
var _sfx_player: AudioStreamPlayer
var _ui_player: AudioStreamPlayer


func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music"
	add_child(_music_player)

	_sfx_player = AudioStreamPlayer.new()
	_sfx_player.bus = "SFX"
	add_child(_sfx_player)

	_ui_player = AudioStreamPlayer.new()
	_ui_player.bus = "UI"
	add_child(_ui_player)

# =========================
# PLAYBACK
# =========================

func play_music(id: String) -> void:
	if not music_library.has(id):
		push_warning("Music not found: " + id)
		return

	_music_player.stream = music_library[id]
	_music_player.play()


func stop_music() -> void:
	_music_player.stop()


func play_sfx(id: String) -> void:
	if not sfx_library.has(id):
		push_warning("SFX not found: " + id)
		return

	_sfx_player.stream = sfx_library[id]
	_sfx_player.play()


func play_ui(id: String) -> void:
	if not ui_library.has(id):
		push_warning("UI sound not found: " + id)
		return

	_ui_player.stream = ui_library[id]
	_ui_player.play()

# =========================
# PAUSE CONTROL (GODOT 4)
# =========================

# Pausa solo gameplay (music + sfx)
func pause_gameplay_audio() -> void:
	_music_player.stream_paused = true
	_sfx_player.stream_paused = true


func resume_gameplay_audio() -> void:
	_music_player.stream_paused = false
	_sfx_player.stream_paused = false


# Pausa absolutamente todo (incluye UI)
func pause_all_audio() -> void:
	_music_player.stream_paused = true
	_sfx_player.stream_paused = true
	_ui_player.stream_paused = true


func resume_all_audio() -> void:
	_music_player.stream_paused = false
	_sfx_player.stream_paused = false
	_ui_player.stream_paused = false

# =========================
# VOLUME CONTROL
# =========================

func set_master_volume(value: float) -> void:
	_set_bus_volume("Master", value)


func set_music_volume(value: float) -> void:
	_set_bus_volume("Music", value)


func set_sfx_volume(value: float) -> void:
	_set_bus_volume("SFX", value)


func set_ui_volume(value: float) -> void:
	_set_bus_volume("UI", value)

# =========================
# INTERNAL
# =========================

func _set_bus_volume(bus_name: String, value: float) -> void:
	var bus := AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus, linear_to_db(clamp(value, 0.0, 1.0)))
