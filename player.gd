extends CharacterBody2D


const SPEED = 300.0
var c = 0

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and c == 1:
		velocity.x = direction * SPEED
	elif direction and c == 2:
		velocity.x = -direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction and c == 3:
		velocity.y = direction * SPEED
	elif direction and c == 4:
		velocity.y = -direction * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
