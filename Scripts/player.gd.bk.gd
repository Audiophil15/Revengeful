extends CharacterBody2D

signal damagetaken(dmg)

var state_machine
var caninterrupt
var direction
var directionold
const SPEED = 100.0
const JUMP_VELOCITY = -200.0

func _ready() -> void:
	state_machine = $AnimationTree["parameters/playback"]
	direction = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("game_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("game_left", "game_right")
	if direction:
		if direction < 0 :
			$Sprite2D.flip_h = true
		if direction > 0 :
			$Sprite2D.flip_h = false
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/2)

	if direction :
		state_machine.travel("Run")
	if not is_on_floor() and velocity.y > 0.9*JUMP_VELOCITY :
		state_machine.travel("Jump")
	if Input.is_action_just_pressed("game_attack_1") :
		state_machine.travel("Attack 1")
	if Input.is_action_just_pressed("game_attack_2") :
		state_machine.travel("Attack 2")

	move_and_slide()
