extends Area2D

@export var fall_speed := 75

func _ready() -> void:
	if randf() > 0.6:
		queue_free()

func _physics_process(delta):
	position.y += fall_speed * delta
			
	if position.y > get_viewport_rect().size.y + 20:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if Game.mundo.current_lives < Game.mundo.max_lives:
			Game.mundo.add_life(1)
			Game.mundo.get_node("collect").play()
			queue_free()
