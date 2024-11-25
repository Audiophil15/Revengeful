extends CharacterBody2D

signal damagetaken(dmg)


@export var interruptable :bool
@export var isjumping :bool
@export var isattacking :int
@export var isdashing :int
@export var maxlife :float
@export var totallife :float
@export var life :float
@export var ishurt :bool
@export var positionrange = [0., 0.]
var candash :bool
var aerialmalus :bool
var direction :int
var directionold :int
const horizontalspeed = 110.0
const jumpvelocity = -300.0
var isfollowing :bool
var isdead :bool

const walkmatrix = [[0.985, 0.015, 0.0], [0.005, 0.99, 0.005], [0.0, 0.015, 0.985]]

func _ready() -> void:
	Globals.BossID = self.get_instance_id()
	Globals.enemiesdamages[self.get_instance_id()] = 15
	interruptable = 1
	isjumping = 0
	isattacking = 0
	isdashing = 0
	totallife = 100.
	life = totallife
	ishurt = false
	candash = 1
	aerialmalus = 0
	direction = 0
	isdead = false
	directionold = direction
	isfollowing = false
	$AnimationPlayer.play("Idle")
	$Hurtbox/CollisionShape2D.disabled = false

func _physics_process(delta: float) -> void:

	print($Hurtbox/CollisionShape2D.disabled)

	if life < totallife :
		$"Healthbar bg".visible = true
		$"Healthbar fg".visible = true
	$"Healthbar fg".scale.x = max(0, life)/totallife
	
	if Globals.playerlife == 0 :
		isfollowing = false

	if life <= 0 :
		isdead = true

	if not is_on_floor():
		velocity += get_gravity() * delta
	else :
		aerialmalus = 0
		candash = 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	directionold = direction
	direction = Maths.weightedchoice([-1,0,1], walkmatrix[direction+1])
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
			if Globals.playerisonfloor and ((position.y-Globals.playerpos.y)>15 and abs(Globals.playerpos.x-position.x)<20) or is_on_wall() :
				isjumping = true
			if abs(Globals.playerpos.x-position.x) < 30 and abs(Globals.playerpos.y-position.y) < 10 :
				isattacking = 1
	
	if ishurt or isdead :
		direction = 0

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

	#print("pos: %s dir: %s aemalus: %s iatk: %s isdsh: %s isofl: %s vel.x: %s maxlife: %s totlife: %s life: %s" % [position, direction, aerialmalus, isattacking, isdashing, is_on_floor(), velocity.x, maxlife, totallife, life])
	#print("hurtbox: %s" % [not $Hurtbox/CollisionShape2D.disabled])
	
	if isdead :
		$AnimationPlayer.play("Death")
		interruptable = false
		await $AnimationPlayer.animation_finished
		self.queue_free()
	
	if ishurt and not isdead :
		$AnimationPlayer.play("Hurt")
		interruptable = false

	if interruptable :	# Some actions may not be interruptable, like death
		if not direction and is_on_floor() and not isattacking :
			$AnimationPlayer.play("Idle")
		if direction and is_on_floor() and not isattacking :
			$AnimationPlayer.play("Run")
		if not isjumping and velocity.y > 0 and not isattacking :
			$AnimationPlayer.play("Fall")
		if isjumping and not isattacking :
			$AnimationPlayer.play("Jump")
		if isattacking == 1 :
			if $Sprite2D.flip_h :
				$AnimationPlayer.play("Attack 1 Left")
			else :
				$AnimationPlayer.play("Attack 1 Right")
			var s = randi_range(1, 2)
			if not $SFXPlayer.playing :
				var sound = load("res://Art/Audio/Sounds/enemy 1-%s.ogg" % [s])
				$SFXPlayer.stream = sound
				$SFXPlayer.play()
		if isattacking == 2 :
			if $Sprite2D.flip_h :
				$AnimationPlayer.play("Attack 2 Left")
			else :
				$AnimationPlayer.play("Attack 2 Right")
		if isdashing :
			$AnimationPlayer.play("Dodge")
			interruptable = false

	move_and_slide()

func _on_sight_body_entered(body: Node2D) -> void:
	if body.get_instance_id() == Globals.PlayerID :
		isfollowing = true

func _on_sight_body_exited(body: Node2D) -> void:
	pass

func _on_sight_extended_body_exited(body: Node2D) -> void:
	if body.get_instance_id() == Globals.PlayerID :
		isfollowing = false

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.get_instance_id() in Globals.playerhitboxes :
		ishurt = true
		life -= 15
