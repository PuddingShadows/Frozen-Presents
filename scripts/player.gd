extends CharacterBody2D

const MAX_SPEED = 280
const ACCELERATION = 450
const FRICTION = 50
const JUMP_FORCE = -400.0


var last_direction = 1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	
	
	var direction := 0
	
	if Input.is_action_just_pressed("ui_right"):
		last_direction = 1
	elif Input.is_action_just_pressed("ui_left"):
		last_direction = -1
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		direction = last_direction
		
	
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * delta)
		
		$boneco.flip_h = direction < 0
	
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	move_and_slide()
