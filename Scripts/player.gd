extends CharacterBody2D

signal damagetaken(dmg)

var interruptable
@export var isjumping = false
@export var isattacking = false
var direction
var directionold
const horizontalspeed = 140.0
const jumpvelocity = -300.0

func _ready() -> void:
	#$"/root/Globals".PlayerID = self.get_instance_id()
	direction = 0
	interruptable = 1
	$AnimationPlayer.play("Idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("game_jump") and is_on_floor():
		velocity.y = jumpvelocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("game_left", "game_right")
	if direction:
		if direction < 0 :
			$Sprite2D.flip_h = true
		if direction > 0 :
			$Sprite2D.flip_h = false
		velocity.x = direction * horizontalspeed
	else:
		velocity.x = move_toward(velocity.x, 0, horizontalspeed/2)
	if isattacking and is_on_floor() :
		velocity.x = 0

	if interruptable :	# Some actions may not be interruptable, like death
		if not direction and is_on_floor() and not isattacking :
			$AnimationPlayer.play("Idle")
		if direction and is_on_floor() and not isattacking :
			$AnimationPlayer.play("Run")
		if not isjumping and velocity.y > 0 and not isattacking :
			$AnimationPlayer.play("Fall")
		if isjumping :
			$AnimationPlayer.play("Jump")
		if Input.is_action_pressed("game_attack_1") :
			isattacking = true
			if $Sprite2D.flip_h :
				$AnimationPlayer.play("Attack 1 Left")
			else :
				$AnimationPlayer.play("Attack 1 Right")
		if Input.is_action_pressed("game_attack_2") :
			isattacking = true
			if $Sprite2D.flip_h :
				$AnimationPlayer.play("Attack 2 Left")
			else :
				$AnimationPlayer.play("Attack 2 Right")

	move_and_slide()
