extends Control

signal tomainmenu

func _ready() -> void:
	var enemyscene = preload("res://Scenes/Enemy 1.tscn")

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
	$Player.position = Vector2(5, 750)
	
	
	

func _process(delta: float) -> void:
	$Camera2D.position = $Player.position
