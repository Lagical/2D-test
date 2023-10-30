extends CharacterBody2D


var speed = 300.0
const default_speed = 300.0
const jump_speed = -400.0
var jump_tracker = 0
var multi_jump = 0
var dash_speed = 2500
var dash = 0
var can_dash = false
var dashing = false
var time_to_dash : float = 0
var time_since_dash : float = 0
var time_to_bhop : float = 0
var wall_sliding = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	walk_and_dash(delta)
	jump(delta)
	wall_slide(delta)
	move_and_slide()
	animations()
	
	
		
func walk_and_dash(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	
	time_since_dash += delta
	time_to_dash += delta
	
	"""if velocity.x == 0 && dashing == true:
		dashing = false
		can_dash = true
		dash = 0
	if Input.is_action_just_pressed("dash") && dash < 2:
		dash += 1
		can_dash = true
		time_to_dash = 0
		
	if time_to_dash > 0.5:
		dash = 0
	
	if dashing == false:
		velocity.x = direction * speed
		if Input.is_action_just_pressed("dash") && can_dash == true && dash == 2:
			velocity.x = direction * dash_speed
			time_since_dash = 0
			dashing = true
			can_dash = false""
	else:
		velocity.x = move_toward(velocity.x, 0, speed)"""
	
	
func jump(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
			if velocity.length() < 800:
				speed += 25
		if is_on_wall() && Input.is_action_pressed("move_right"):
			velocity.y = jump_speed
			velocity.x = -200
		if is_on_wall() && Input.is_action_pressed("move_left"):
			velocity.y = jump_speed
			velocity.x = 200
	
	#stops bunny hopping	
	if velocity.x != 0 && velocity.y == 0:
		speed = default_speed

func wall_slide(delta):
	if is_on_wall() && !is_on_floor():
		if Input.is_action_pressed("move_left") || Input.is_action_pressed("ui_right"):
			wall_sliding = true
		else:
			wall_sliding = false
	else:
		wall_sliding = false	
	if wall_sliding:
		velocity.y += (100 * delta)
		velocity.y = min(velocity.y, 100)
		print(velocity.y)
	
	
	
func animations():
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
