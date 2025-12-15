extends AudioBackend
class_name GodotAudioBackend

# ============================================================
# AUDIO LIBRARIES (CONFIGURACIÓN DESDE EL INSPECTOR)
# ============================================================
#
# Estos diccionarios se configuran MANUALMENTE desde el editor.
#
# Clave (Key):
# - String que identifica el sonido
# - Es el ID que usará el gameplay
#   Ej: "jump", "pickup", "menu_click"
#
# Valor (Value):
# - Archivo de audio importado en Godot
# - Tipo: AudioStream (.wav, .ogg, etc.)
#
# IMPORTANTE:
# - NO usar rutas
# - NO cargar sonidos por código
# - TODOS los sonidos del juego deben registrarse aquí
#

@export var music_library: Dictionary = {}
@export var sfx_library: Dictionary = {}
@export var ui_library: Dictionary = {}
@export var sfx_pool_size: int = 8

# ============================================================
# AUDIO PLAYERS (RUNTIME)
# ============================================================

var _music_player: AudioStreamPlayer
var _sfx_players: Array[AudioStreamPlayer] = []
var _ui_player: AudioStreamPlayer
var _sfx_last_used: Dictionary = {}


func _ready() -> void:
    # Estos reproductores se crean UNA SOLA VEZ
    # cuando el AudioManager entra en escena (autoload).

    _music_player = AudioStreamPlayer.new()
    _music_player.bus = "Music" # Debe existir en el Audio Bus Layout
    add_child(_music_player)

    for i in range(max(1, sfx_pool_size)):
        var sfx_player := AudioStreamPlayer.new()
        sfx_player.bus = "SFX" # Debe existir en el Audio Bus Layout
        add_child(sfx_player)
        _sfx_players.append(sfx_player)
        _sfx_last_used[sfx_player] = 0

    _ui_player = AudioStreamPlayer.new()
    _ui_player.bus = "UI" # Debe existir en el Audio Bus Layout
    add_child(_ui_player)

# ============================================================
# PLAYBACK
# ============================================================

func play_music(id: String) -> void:
    # Reproduce música registrada en music_library
    if not music_library.has(id):
        push_warning("Music not found: " + id)
        return

    _music_player.stream = music_library[id]
    _music_player.play()


func stop_music() -> void:
    _music_player.stop()


func play_sfx(id: String) -> void:
    # Reproduce efectos registrados en sfx_library
    if not sfx_library.has(id):
        push_warning("SFX not found: " + id)
        return

    var player := _get_available_sfx_player()
    player.stream = sfx_library[id]
    player.play()
    _sfx_last_used[player] = Time.get_ticks_msec()


func play_ui(id: String) -> void:
    # Reproduce sonidos de interfaz registrados en ui_library
    if not ui_library.has(id):
        push_warning("UI sound not found: " + id)
        return

    _ui_player.stream = ui_library[id]
    _ui_player.play()

# ============================================================
# PAUSE CONTROL
# ============================================================

# Pausa solo audio de gameplay (música + sfx)
func pause_gameplay_audio() -> void:
    _music_player.stream_paused = true
    for player in _sfx_players:
        player.stream_paused = true


func resume_gameplay_audio() -> void:
    _music_player.stream_paused = false
    for player in _sfx_players:
        player.stream_paused = false


# Pausa absolutamente todo (incluye UI)
func pause_all_audio() -> void:
    _music_player.stream_paused = true
    for player in _sfx_players:
        player.stream_paused = true
    _ui_player.stream_paused = true


func resume_all_audio() -> void:
    _music_player.stream_paused = false
    for player in _sfx_players:
        player.stream_paused = false
    _ui_player.stream_paused = false

# ============================================================
# VOLUME CONTROL
# ============================================================

func set_master_volume(value: float) -> void:
    _set_bus_volume("Master", value)


func set_music_volume(value: float) -> void:
    _set_bus_volume("Music", value)


func set_sfx_volume(value: float) -> void:
    _set_bus_volume("SFX", value)


func set_ui_volume(value: float) -> void:
    _set_bus_volume("UI", value)

# ============================================================
# INTERNAL
# ============================================================

func _set_bus_volume(bus_name: String, value: float) -> void:
    var bus := AudioServer.get_bus_index(bus_name)
    AudioServer.set_bus_volume_db(
            bus,
            linear_to_db(clamp(value, 0.0, 1.0))
    )


func _get_available_sfx_player() -> AudioStreamPlayer:
    for player in _sfx_players:
        if not player.playing:
            return player

    var oldest_player := _sfx_players[0]
    var oldest_tick := _sfx_last_used.get(oldest_player, 0)
    for player in _sfx_players:
        var last_tick: int = _sfx_last_used.get(player, 0)
        if last_tick < oldest_tick:
            oldest_tick = last_tick
            oldest_player = player

    oldest_player.stop()
    return oldest_player
