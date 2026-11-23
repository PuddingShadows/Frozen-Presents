extends Control

func _on_voltar_pressed() -> void:
	visible = false
	get_tree().current_scene.get_node("menu_control").visible = true
