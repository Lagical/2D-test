extends CharacterBody2D


var SPEED = 300.0
const default_speed = 300.0
const JUMP_VELOCITY = -400.0
var jump_tracker = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_tracker += 1
		print(velocity.length())
		if velocity.length() > 400 && jump_tracker > 1:
			SPEED += 25
		elif velocity.length() == 400 && jump_tracker > 1:
			print("toimi")
			SPEED = default_speed
			jump_tracker = 0

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if velocity.x != 0 && velocity.y == 0:
		SPEED = default_speed
	
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "jump"

	move_and_slide()
