extends Control

signal tomainmenu

var bossscene = preload("res://Scenes/Boss.tscn")

var xyo
var xye
var initialplayerpos

func _ready() -> void:
	Globals.enemiesplacement = []
	
	# Map generation
	xyo = Vector2i(0, 25)
	
	#$Map.testmap(xyo)
	$Map.islevel = false
	xye = $Map.generatebossroom(xyo)
	
	$Camera.limit_right = (xye[0]-1)*16
	
	var bossinstance = bossscene.instantiate()
	bossinstance.position = Vector2(650, xye[1]-25)
	add_child(bossinstance)
	
func _process(delta: float) -> void:
	pass
