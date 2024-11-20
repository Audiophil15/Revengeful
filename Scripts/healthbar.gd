extends Node2D

@export var length :float
@export var percentfill :float
@export var width :float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	percentfill = max(0, percentfill)
	percentfill = min(percentfill, 1)
	$"Healthbar fg".scale.x = percentfill

func setlength(l) :
	length = l
	$"Healthbar bg".points[1].x = l
	$"Healthbar fg".points[1].x = l
	
func setwidth(width) :
	$"Healthbar bg".width = width
	$"Healthbar fg".width = width
	
