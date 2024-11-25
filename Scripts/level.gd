extends Control

signal tomainmenu

var enemyscene = preload("res://Scenes/Enemy 1.tscn")

var xyo
var initialplayerpos

func _ready() -> void:
	Globals.enemiesplacement = []
	
	# Map generation
	xyo = Vector2i(0, 25)
	
	initialplayerpos = Vector2(15, 16*xyo[1]-150)
	#$Map.testmap(xyo)
	xyo = $Map.generatemap(xyo, 150, $Map.markovmatrix)
	print(xyo, xyo[0]*16)
	$Camera2D.position = $Player.position
	$Camera2D.limit_right = xyo[0]*16
	
	# Enemies added according to the map info
	#print(Globals.enemiesplacement)
	for pos in Globals.enemiesplacement :
		#continue
		var enemy = enemyscene.instantiate()
		enemy.position = pos
		enemy.positionrange = [pos.x-50, pos.x+50]
		add_child(enemy)
		print("enemy added")
	
	# Preparing the player
	$Player.position = initialplayerpos
	$Player.settotallife($Player.maxlife)
	
	Globals.runstart = Time.get_ticks_msec()

func _process(delta: float) -> void:
	$Camera2D.position = $Player.position

func _on_player_dead() -> void:
	$Player.rebirth(initialplayerpos)
