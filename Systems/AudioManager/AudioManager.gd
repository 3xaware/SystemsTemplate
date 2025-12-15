extends Node

@onready var _backend: AudioBackend = $GodotAudioBackend

func _ready() -> void:
	GameFlow.state_changed.connect(_on_game_state_changed)

# =========================
# PUBLIC API
# =========================

func play_music(id: String) -> void:
	_backend.play_music(id)

func stop_music() -> void:
	_backend.stop_music()

func play_sfx(id: String) -> void:
	_backend.play_sfx(id)

func play_ui(id: String) -> void:
	_backend.play_ui(id)

func set_master_volume(value: float) -> void:
	_backend.set_master_volume(value)

func set_music_volume(value: float) -> void:
	_backend.set_music_volume(value)

func set_sfx_volume(value: float) -> void:
	_backend.set_sfx_volume(value)

func set_ui_volume(value: float) -> void:
	_backend.set_ui_volume(value)

# =========================
# GAME FLOW REACTIONS
# =========================

func _on_game_state_changed(_prev, current) -> void:
	match current:
		GameFlow.State.PAUSED:
			_backend.pause_gameplay_audio()
		GameFlow.State.GAMEPLAY:
			_backend.resume_gameplay_audio()
