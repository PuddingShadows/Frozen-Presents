extends Control



func _on_começar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mundo.tscn")

func _on_sair_pressed() -> void:
	get_tree().quit()


func _on_creditos_pressed() -> void:
	get_tree().current_scene.get_node("creditos").visible = true
	visible = false
