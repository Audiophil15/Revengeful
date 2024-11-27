extends Control

signal playerreachedend

var enemyscene = preload("res://Scenes/Enemy 1.tscn")

@export var xyo: Vector2i
@export var xye: Vector2i

func _ready() -> void:
	
	Globals.enemiesplacement = []
	
	# Map generation
	xyo = Vector2i(0, 25)
	
	#$Map.testmap(xyo)
	xye = $Map.generatelevel(xyo, 100, $Map.markovmatrix)
	$Map/Door.connect("playerentered", playerfinishedlevel)
	
	$Camera.limit_right = xye[0]*16

	# Enemies added according to the map info
	#print(Globals.enemiesplacement)
	for pos in Globals.enemiesplacement :
		#continue
		var enemy = enemyscene.instantiate()
		enemy.position = pos
		enemy.positionrange = [pos.x-50, pos.x+50]
		add_child(enemy)
	
	Globals.runstart = Time.get_ticks_msec()

func _process(delta: float) -> void:
	pass

func playerfinishedlevel() :
	emit_signal("playerreachedend")
