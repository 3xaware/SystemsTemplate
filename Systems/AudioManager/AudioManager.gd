extends Node

# Existe un AudioManager.tscn que contiene 2 nodos, uno sera el AudioManager (Node) al que se le pegara este script, y tendra como hijo un GodotAudioBackend (Node) Con GodotAudioBackend.gd asignado (Esto ya esta en el proyecto) y es el nodo al que hace referencia esta variable _backend (Ahi en el GodotAudioBackend se arrastran los archivos de audio)
@onready var _backend: AudioBackend = $GodotAudioBackend

func _ready() -> void:
	GameFlow.state_changed.connect(_on_game_state_changed)

# =========================
# API PÚBLICA
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
