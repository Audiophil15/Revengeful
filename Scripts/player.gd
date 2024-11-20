extends CharacterBody2D

signal damagetaken(dmg)
signal dead

@export var interruptable :bool
@export var isjumping :bool
@export var isattacking :int = 0
@export var isdashing :int = 0
@export var maxlife :float = 100
@export var totallife :float = 100
@export var life :float = 100
@export var ishurt :bool
var candash :bool
var aerialmalus :bool
var direction :int
var directionold :int
var isdead :bool
var hasdied :bool
const horizontalspeed = 140.0
const jumpvelocity = -300.0

func _ready() -> void:
	Globals.PlayerID = self.get_instance_id()
	Globals.playerhitboxes.append($"Hitbox Left".get_instance_id())
	Globals.playerhitboxes.append($"Hitbox Right".get_instance_id())
	Globals.playertotallife = totallife
	interruptable = 1
	isjumping = 0
	isattacking = 0
	isdashing = 0
	totallife = 100
	life = totallife
	ishurt = false
	candash = 1
	aerialmalus = 0
	direction = 0
	directionold = direction
	isdead = false
	hasdied = false
	$AnimationPlayer.play("Idle")
	$"Dash Sprites/Sprite2D2".visible = false
	$"Dash Sprites/Sprite2D3".visible = false
	$"Dash Sprites/Sprite2D4".visible = false

func _physics_process(delta: float) -> void:
	# Add the gravity.

	if life <= 0 :
		isdead = true

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
	if ishurt :
		direction = 0

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
		velocity.x = (-1 + 2*int(not $Sprite2D.flip_h)) * horizontalspeed * 1.8
		velocity.y = 0
	if ishurt or isdead :
		direction = 0
	
	print("pos: %s dir: %s aemalus: %s iatk: %s isdsh: %s isofl: %s vel.x: %s totlife: %s maxlife: %s life: %s" % [position, direction, aerialmalus, isattacking, isdashing, is_on_floor(), velocity.x, totallife, maxlife, life])
	print("isdead: %s hasdied: %s ishurt: %s interpt: %s hurtbox: %s" % [isdead, hasdied, ishurt, interruptable, not $Hurtbox/CollisionShape2D.disabled])

	if isdead and not hasdied:
		hasdied = true
		interruptable = false
		$AnimationPlayer.play("Death")
		await $AnimationPlayer.animation_finished
		emit_signal("dead")

	if ishurt :
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
		if isattacking == 2 :
			if $Sprite2D.flip_h :
				$AnimationPlayer.play("Attack 2 Left")
			else :
				$AnimationPlayer.play("Attack 2 Right")
		if isdashing :
			$AnimationPlayer.play("Dodge")
			interruptable = false

	move_and_slide()

	Globals.playerpos = position
	Globals.playerisonfloor = is_on_floor()
	Globals.playertotallife = totallife
	Globals.playerlife = life

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var id = area.get_parent().get_instance_id()
	if id in Globals.enemiesIDs :
		gethurt(Globals.enemiesdamages[id])

func gethurt(damage) :
	life -= damage
	ishurt = true
	
func reducemaxlife(qty) :
	maxlife -= qty
	
func death() :
	$AnimationPlayer.play("Death")
	emit_signal("dead")
	
func settotallife(amount) :
	totallife = min(amount, maxlife)
	life = totallife
	
func rebirth(position) :
	isdead = false
	hasdied = false
	settotallife(totallife*0.9)
	self.position = position
