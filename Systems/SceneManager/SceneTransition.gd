extends CanvasLayer
class_name SceneTransition

@onready var rect: ColorRect = $ColorRect

var animating: bool = false

func set_background(bg: Texture2D) -> void:
	if bg != null:
		rect.texture = bg
		rect.color = Color.WHITE # textura visible
	else:
		rect.texture = null
		rect.color = Color.BLACK # fallback


func fade_out(duration: float, custom_bg: Texture2D = null) -> void:
	animating = true
	InputBlocker.block_input()

	set_background(custom_bg)
	rect.visible = true
	rect.modulate.a = 0.0

	var tween := create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, duration)
	await tween.finished


func fade_in(duration: float) -> void:
	var tween := create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, duration)
	await tween.finished

	rect.visible = false
	rect.texture = null
	animating = false
	InputBlocker.unblock_input()
