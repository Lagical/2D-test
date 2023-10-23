extends CharacterBody2D


var SPEED = 300.0
const default_speed = 300.0
const JUMP_VELOCITY = -400.0
var jump_tracker = 0
var multi_jump = 0
var can_dash = true
var dashing = false
var direction = 0
var dash_direction = 0
var time_since_movement : float = 10
var time_since_dash : float = 0
var current_velocity = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	print(velocity.length())
	# Handle Jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if velocity.length() < 800:
			SPEED += 25
	
	"""if Input.is_action_pressed("jump") && not is_on_floor():
		velocity.y = JUMP_VELOCITY
		multi_jump = 0"""
		
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	#stops bunny hopping
	if velocity.x != 0 && velocity.y == 0:
		SPEED = default_speed
	
	#animation stuff
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
