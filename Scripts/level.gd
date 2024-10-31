extends Control

func _ready() -> void:
	$Camera2D.position = $Player.position
	var xyo = Vector2i(0, 50)
	$Map.testmap()
	#var seq = $Map.generatesequence(100, $Map.markovmatrix)
	#$Map.sequencetotiles(seq, xyo)
	$Player.position = Vector2(5, 750)

func _process(delta: float) -> void:
	$Camera2D.position = $Player.position
