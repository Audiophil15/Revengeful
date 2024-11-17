extends CharacterBody2D

signal damagetaken(dmg)
signal dead

@export var interruptable = 1
@export var isjumping = 0
@export var isattacking :int = 0
@export var isdashing :int = 0
@export var maxlife :int = 100
@export var life :int = 100
var candash = 1
var aerialmalus = 0
var direction
var directionold
const horizontalspeed = 140.0
const jumpvelocity = -300.0

func _ready() -> void:
	Globals.PlayerID = self.get_instance_id()
	direction = 0
	interruptable = 1
	$AnimationPlayer.play("Idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.

	if not is_on_floor():
		velocity += get_gravity() * delta
	else :
		aerialmalus = 0
		candash = 1

	# Handle jump.
	#if Input.is_action_just_pressed("game_jump") and is_on_floor():
		#velocity.y = jumpvelocity
		#isjumping = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	directionold = direction
	direction = Input.get_axis("game_left", "game_right")
	if Input.is_action_just_pressed("game_jump") and is_on_floor():
		isjumping = true
	if Input.is_action_just_pressed("game_attack_1") :
		isattacking = 1
	if Input.is_action_just_pressed("game_attack_2") :
		isattacking = 2
	if Input.is_action_just_pressed("game_dodge") and candash :
		isdashing = 1
		candash = 0

	#if direction:
	if direction < 0 :
		$Sprite2D.flip_h = true
		$"Dash Sprites".scale.x = -1
	if direction > 0 :
		$Sprite2D.flip_h = false
		$"Dash Sprites".scale.x = 1

	if direction :
		velocity.x = direction * horizontalspeed
		if not is_on_floor() and abs(directionold - direction) == 2 :
			aerialmalus = 1
	else:
		velocity.x = move_toward(velocity.x, 0, horizontalspeed/2)
	if isattacking and is_on_floor() :
		velocity.x = 0
	if isjumping and velocity.y == 0 :
		velocity.y = jumpvelocity
	if isjumping and velocity.y > 0 :
		isjumping = 0
	if aerialmalus :
		velocity.x *= 0.3
	if isdashing :
		velocity.x = horizontalspeed * 1.8
		velocity.y = 0
	#if direction :
		#velocity.x = (direction * horizontalspeed)*int(not (isattacking and is_on_floor()))*(1-0.7*int(aerialmalus))*(1+0.2*int(isdashing))
	#else :
		#move_toward(velocity.x, 0, horizontalspeed/2)

	print("pos: %s dir: %s aemalus: %s iatk: %s isdsh: %s isofl: %s vel.x: %s" % [position, direction, aerialmalus, isattacking, isdashing, is_on_floor(), velocity.x])

	if interruptable :	# Some actions may not be interruptable, like death
		if not direction and is_on_floor() and not isattacking :
			$AnimationPlayer.play("Idle")
		if direction and is_on_floor() and not isattacking :
			$AnimationPlayer.play("Run")
		if not isjumping and velocity.y > 0 and not isattacking :
			$AnimationPlayer.play("Fall")
		if isjumping and not isattacking :
			$AnimationPlayer.play("Jump")
		if isdashing :
			$AnimationPlayer.play("Dodge")
			interruptable = false
		if isattacking == 1 :
			if $Sprite2D.flip_h :
				$AnimationPlayer.play("Attack 1 Left")
			else :
				$AnimationPlayer.play("Attack 1 Right")
		if isattacking == 2 :
			if $Sprite2D.flip_h :
				$AnimationPlayer.play("Attack 2 Left")
			else :
				$AnimationPlayer.play("Attack 2 Right")

	move_and_slide()

	Globals.playerpos = position
	Globals.playerisonfloor = is_on_floor()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.get_parent().get_instance_id() in Globals.enemiesIDs :
		gethurt(9)

func gethurt(damage) :
	life -= damage
	
func reducemaxlife(qty) :
	maxlife -= qty
	
func death() :
	$AnimationPlayer.play("Death")
	emit_signal("dead")
