extends Node
class_name AudioBackend

# =========================
# PLAYBACK
# =========================

func play_music(_id: String) -> void: pass
func stop_music() -> void: pass
func play_sfx(_id: String) -> void: pass
func play_ui(_id: String) -> void: pass

# =========================
# PAUSE CONTROL
# =========================

func pause_gameplay_audio() -> void: pass
func resume_gameplay_audio() -> void: pass

func pause_all_audio() -> void: pass
func resume_all_audio() -> void: pass

# =========================
# VOLUME CONTROL
# =========================

func set_master_volume(_value: float) -> void: pass
func set_music_volume(_value: float) -> void: pass
func set_sfx_volume(_value: float) -> void: pass
func set_ui_volume(_value: float) -> void: pass
