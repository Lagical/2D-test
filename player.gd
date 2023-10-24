extends CharacterBody2D


var SPEED = 300.0
const default_speed = 300.0
const JUMP_VELOCITY = -400.0
var jump_tracker = 0
var multi_jump = 0
var dash = 0
var can_dash = false
var dashing = false
var direction = 0
var time_to_dash : float = 0
var time_since_dash : float = 0
var current_velocity = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	time_since_dash += delta
	time_to_dash += delta
	
	if velocity.x == 0 && dashing == true:
		dashing = false
		can_dash = true
		dash = 0
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		multi_jump = 0
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") && multi_jump < 2:
		velocity.y = JUMP_VELOCITY
		multi_jump += 1
		if velocity.length() < 800 && is_on_floor():
			SPEED += 25
		
	direction = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_just_pressed("dash") && dash < 2:
		dash += 1
		can_dash = true
		time_to_dash = 0
		
	if time_to_dash > 0.5:
		dash = 0
	
	print(dash)
	
	if dashing == false:
		velocity.x = direction * SPEED
		if Input.is_action_just_pressed("dash") && can_dash == true && dash == 2:
			print("???")
			velocity.x = direction * 3000
			time_since_dash = 0
			dashing = true
			can_dash = false
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
