extends Label
func _process(delta):
	text = str(int(Engine.get_frames_per_second())) + " FPS"


func _on_fps_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		visible = true
	else:
		visible = false
