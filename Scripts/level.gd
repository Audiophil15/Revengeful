extends Control

signal tomainmenu

var enemyscene = preload("res://Scenes/Enemy 1.tscn")

func _ready() -> void:
	$Camera2D.position = $Player.position
	
	# Map generation
	var xyo = Vector2i(0, 50)
	$Map.testmap()
	#var seq = $Map.generatesequence(100, $Map.markovmatrix)
	#$Map.sequencetotiles(seq, xyo)
	
	# Enemies added according to the map info
	print(Globals.enemiesplacement)
	for pos in Globals.enemiesplacement :
		var enemy = enemyscene.instantiate()
		enemy.position = pos
		enemy.positionrange = [pos.x-50, pos.x+50]
		add_child(enemy)
	
	# Preparing the player
	$Player.position = Vector2(5, 750)
	$Player.settotallife($Player.maxlife)

func _process(delta: float) -> void:
	$Camera2D.position = $Player.position

func _on_player_dead() -> void:
	$Player.rebirth(Vector2(5, 750))
