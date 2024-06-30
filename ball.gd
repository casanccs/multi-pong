extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		print("collide")
		var collider = collision.get_collider()
		if collider.is_in_group("h"):
			velocity.y *= -1
		elif collider.is_in_group("v"):
			velocity.x *= -1
		elif collider.is_in_group("hp"):
			velocity.y *= -1
			velocity.x *= 1.2
		elif collider.is_in_group("vp"):
			velocity.x *= -1
			velocity.y *= 1.2
