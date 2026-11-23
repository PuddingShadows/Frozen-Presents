extends Area2D

@export var fall_speed := 25
@export var present_texture : Array[Texture2D]

@onready var sprite = $presente


func _ready():
	Game.present_count += 1
	add_to_group("present")
	if randf() > 0.2:
		queue_free()
	
	if present_texture.size() > 0:
		sprite.texture = present_texture.pick_random()

func _physics_process(delta):
	position.y += fall_speed * delta
	
	if position.y > get_viewport_rect().size.y + 20:
		var current_scene = get_tree().current_scene
		if current_scene.name == "mundo":
			Game.mundo.lose_life(2)
		queue_free()

func _exit_tree() -> void:
	Game.present_count -= 1


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		Game.mundo.add_big_present()
		Game.mundo.get_node("collect").play()
		queue_free()
