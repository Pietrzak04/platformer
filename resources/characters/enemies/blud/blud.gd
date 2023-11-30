extends Characters

@onready var sprite = $AnimatedSprite2D
@onready var animation = $AnimationPlayer
@onready var idle_timer = $IdleTimer
@onready var detection = $PlayerDetect
@onready var demage = $DemageBox

enum State {
	IDLE,
	RUN,
	ATTACK
}

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1.0
var current_state = State.RUN

func flip(direction):
	if direction > 0.0:
		sprite.scale.x = 1
		sprite.position.x = 1
		detection.scale.x = 1
		demage.scale.x = 1
	else:
		sprite.scale.x = -1
		sprite.position.x = -1
		detection.scale.x = -1
		demage.scale.x = -1

func attack_finished():
	current_state = State.RUN

func _physics_process(delta):
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO
			animation.play("idle")
		State.RUN:
			animation.play("run")
			
			if is_on_wall():
				direction *= -1
			
			velocity.y += gravity * delta
			velocity.x = direction * speed
			
			flip(direction)
		State.ATTACK:
			animation.play("attack")
			velocity = Vector2.ZERO
	
	move_and_slide()


func _on_idle_timer_timeout():
	if current_state == State.IDLE:
		current_state = State.RUN
		idle_timer.wait_time = randf_range(8.0, 14.0)
		idle_timer.start()
	elif current_state == State.RUN:
		current_state = State.IDLE
		idle_timer.wait_time = randf_range(1.0, 3.0)
		idle_timer.start()


func _on_player_detect_body_entered(body):
	current_state = State.ATTACK


func _on_demage_box_body_exited(body):
	body.hit()
