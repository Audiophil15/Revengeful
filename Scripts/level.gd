extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var xyo = Vector2i(0, 50)
	$Camera2D.position = $Player.position
	var seq = $Map.generatesequence(100, $Map.markovmatrix)
	$Map.sequencetotiles(seq, xyo)
	$Player.position = Vector2(5, 750)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Camera2D.position = $Player.position
	pass
