extends CharacterBody2D

signal damagetaken(dmg)

@export var interruptable = 1
@export var isjumping = 0
@export var isattacking :int = 0
@export var isdashing :int = 0
@export var positionrange = [0., 0.]
var candash = 1
var aerialmalus = 0
var direction
var directionold
const horizontalspeed = 20.0
const jumpvelocity = -300.0
var isfollowing = false

const walkmatrix = [[0.985, 0.015, 0.0], [0.005, 0.99, 0.005], [0.0, 0.015, 0.985]]

func _ready() -> void:
	Globals.enemiesIDs.append(self.get_instance_id())
	direction = 0
	interruptable = 1
	$AnimationPlayer.play("Idle")

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
	else :
		aerialmalus = 0
		candash = 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	directionold = direction
	direction = Maths.weightedchoice([-1,0,1], walkmatrix[direction+1]) #Input.get_axis("game_left", "game_right")
	if not isfollowing :
		if position.x < positionrange[0] :
			direction = min(direction+1, 1)
		if position.x > positionrange[1] :
			direction = max(direction-1, -1)
		if is_on_floor() and direction and directionold == direction and is_on_wall() :
			direction = 0
			
	if isfollowing :
		direction = sign(Globals.playerpos.x - position.x)
		if is_on_floor() :
			if Globals.playerisonfloor and (position.y-Globals.playerpos.y)>25 and abs(Globals.playerpos.x-position.x)<50 :
				isjumping = true
			if abs(Globals.playerpos.x-position.x) < 30 and abs(Globals.playerpos.y-position.y) < 10 :
				isattacking = 1
			
		
	#if Input.is_action_just_pressed("game_jump") and is_on_floor():
		#isjumping = true
	#if Input.is_action_just_pressed("game_attack_1") :
		#isattacking = 1
	#if Input.is_action_just_pressed("game_attack_2") :
		#isattacking = 2
	#if Input.is_action_just_pressed("game_dodge") and candash :
		#isdashing = 1
		#candash = 0

	#if direction:
	if direction < 0 :
		$Sprite2D.flip_h = true
		$Sight/Shape.position.x = -47
	if direction > 0 :
		$Sprite2D.flip_h = false
		$Sight/Shape.position.x = 47

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
		velocity.x *= 1.8
		velocity.y = 0
	#if direction :
		#velocity.x = (direction * horizontalspeed)*int(not (isattacking and is_on_floor()))*(1-0.7*int(aerialmalus))*(1+0.2*int(isdashing))
	#else :
		#move_toward(velocity.x, 0, horizontalspeed/2)

	#print("pos: %s dir: %s aemalus: %s iatk: %s isdsh: %s isofl: %s vel.x: %s" % [position, direction, aerialmalus, isattacking, isdashing, is_on_floor(), velocity.x])

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
	


func _on_sight_body_entered(body: Node2D) -> void:
	if body.get_instance_id() == Globals.PlayerID :
		isfollowing = true

func _on_sight_body_exited(body: Node2D) -> void:
	if body.get_instance_id() == Globals.PlayerID :
		isfollowing = false
