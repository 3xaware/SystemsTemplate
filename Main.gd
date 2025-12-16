extends Node2D

func _ready() -> void:
        if has_node("/root/AudioManager"):
                AudioManager.play_music("music_sound_1")
                AudioManager.play_sfx("sfx_sound_1")
        else:
                push_warning("AudioManager autoload not found; initial audio playback skipped.")
