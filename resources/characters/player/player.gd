extends Characters

@onready var sprite = $Sprite2D
@onready var animation_tree = $AnimationTree

@export var acceleration = 0.2
@export var jump_speed = -300.0

const state_move = ["idle", "run"]
const state_jump = ["fall", "jump"]
const state_ground_air = ["air", "ground"]

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_counter = 0

func flip(direction):
	if direction == 0.0: return
	
	if direction > 0.0:
		sprite.scale.x = 1
		sprite.position.x = 7
	else:
		sprite.scale.x = -1
		sprite.position.x = -7
func animation(direction):
	animation_tree.set("parameters/move/transition_request", state_move[abs(direction)])
	animation_tree.set("parameters/jump_fall/transition_request", state_jump[int(velocity.y < 0)])
	animation_tree.set("parameters/ground_air/transition_request", state_ground_air[int(is_on_floor())])

func hit():
	print("player demage")

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and jump_counter < 2:
		jump_counter += 1
		velocity.y = jump_speed
	
	var direction = Input.get_axis("left", "right")
	
	if direction != 0:
		velocity.x = lerp(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, acceleration)
	
	
	flip(direction)
	animation(direction)
	
	if is_on_floor():
		jump_counter = 0
	elif jump_counter == 0:
		jump_counter = 1
	
	move_and_slide()
