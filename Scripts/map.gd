extends Node2D

var tilesspace = []
const markovmatrix = [
	[0.750, 0.050, 0.050, 0.030, 0.030, 0.020, 0.030, 0.030, 0.010, 0.000, 0.000],	#0
	[0.775, 0.025, 0.050, 0.030, 0.030, 0.020, 0.030, 0.030, 0.010, 0.000, 0.000],	#1
	[0.775, 0.050, 0.025, 0.030, 0.030, 0.020, 0.030, 0.030, 0.010, 0.000, 0.000],	#2
	[0.800, 0.000, 0.050, 0.030, 0.030, 0.020, 0.030, 0.030, 0.010, 0.000, 0.000],	#3
	[0.800, 0.050, 0.000, 0.030, 0.030, 0.020, 0.030, 0.030, 0.010, 0.000, 0.000],	#4
	[0.765, 0.050, 0.050, 0.030, 0.030, 0.005, 0.030, 0.030, 0.010, 0.000, 0.000],	#5
	[0.808, 0.050, 0.050, 0.030, 0.030, 0.020, 0.001, 0.001, 0.010, 0.000, 0.000],	#6
	[0.808, 0.050, 0.050, 0.030, 0.030, 0.020, 0.001, 0.001, 0.010, 0.000, 0.000],	#7
	[0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.400, 0.600],	#8
	[0.750, 0.920, 0.010, 0.010, 0.010, 0.010, 0.010, 0.010, 0.010, 0.000, 0.000],	#9
	[0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.800, 0.200],	#10
]

var test = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if test :
		var v = Vector2i(0,50)
		for i in range(10) :
			v = generatechunk(0, v)
		for k in range(1,6) :
			for i in range(2) :
				v = generatechunk(k, v)
		
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func tprocess(_delta: float) -> void:
	#pass

func generatetable(sizex, sizey) :
	var table = []
	for i in range(sizex) :
		table.append([])
		for j in range(sizey) :
			table[i].append(-1)
	return table

func generatesequence(len, mm) :
	var seq = [0.,0.,0.,0.,0.]
	var values = range(11)
	var c = 0
	for i in range(len-1) :
		c = Maths.weightedchoice(values, mm[c])
		seq.append(c)
	return seq

func generatechunk(id: int, xyo: Vector2i) :
	var dx = 0
	var dy = 0
	match id :
		0 :
			$Ground.set_cell(xyo, 0, Vector2i(3, 6))
			dx += 1
		1 :
			$Ground.set_cell(xyo, 0, Vector2i(3, 6))
			$Ground.set_cell(xyo+Vector2i(1,0), 0, Vector2i(3, 12))
			$Ground.set_cell(xyo+Vector2i(1,-1), 0, Vector2i(1, 6))
			$Ground.set_cell(xyo+Vector2i(2,-1), 0, Vector2i(3, 6))
			dx += 2
			dy += -1
		2 :
			$Ground.set_cell(xyo, 0, Vector2i(3, 6))
			$Ground.set_cell(xyo+Vector2i(1,0), 0, Vector2i(14, 6))
			$Ground.set_cell(xyo+Vector2i(1,1), 0, Vector2i(1, 12))
			$Ground.set_cell(xyo+Vector2i(2,1), 0, Vector2i(3, 6))
			dx += 2
			dy += 1
		3 :
			$Ground.set_cell(xyo, 0, Vector2i(3, 6))
			$Ground.set_cell(xyo+Vector2i(1,0), 0, Vector2i(3, 12))
			$Ground.set_cell(xyo+Vector2i(1,-1), 0, Vector2i(1, 7))
			$Ground.set_cell(xyo+Vector2i(1,-2), 0, Vector2i(1, 6))
			$Ground.set_cell(xyo+Vector2i(2,-2), 0, Vector2i(3, 6))
			dx += 2
			dy += -2
		4 :
			$Ground.set_cell(xyo, 0, Vector2i(3, 6))
			$Ground.set_cell(xyo+Vector2i(1,0), 0, Vector2i(14, 6))
			$Ground.set_cell(xyo+Vector2i(1,1), 0, Vector2i(1, 7))
			$Ground.set_cell(xyo+Vector2i(1,2), 0, Vector2i(1, 12))
			$Ground.set_cell(xyo+Vector2i(2,2), 0, Vector2i(3, 6))
			dx += 2
			dy += 2
		5 :
			var span = randi_range(1, 3)
			for i in range(6+span) : 	# 2 of ground and 1 of platform each side + the span of the middle part
				$Ground.set_cell(xyo+Vector2i(i, 0), 0, Vector2i(3, 6))
			$Ground.set_cell(xyo+Vector2i(2, -1), 0, Vector2i(2, 5))
			$Ground.set_cell(xyo+Vector2i(2, -2), 0, Vector2i(2, 4))
			$Ground.set_cell(xyo+Vector2i(2+span+1, -1), 0, Vector2i(4, 5))
			$Ground.set_cell(xyo+Vector2i(2+span+1, -2), 0, Vector2i(4, 4))
			for i in range(span) :
				$Ground.set_cell(xyo+Vector2i(3+i, -2), 0, Vector2i(3, 4))
			dx += 6 + span # 2 of ground and 1 of platform each side + the span of the middle part
		6 :
			for i in range(3) :
				for j in range(2) :
					$Ground.set_cell(xyo+Vector2i(i+j, -i), 0, Vector2i(3, 6))
			$Ground.set_cell(xyo+Vector2i(2, 0), 0, Vector2i(3, 12))
			$Ground.set_cell(xyo+Vector2i(5, -1), 0, Vector2i(3, 12))
			dx += 6
			dy += 2
		7 :
			for i in range(3) :
				for j in range(2) :
					$Ground.set_cell(xyo+Vector2i(i+j, i), 0, Vector2i(3, 6))
			$Ground.set_cell(xyo+Vector2i(1, 1), 0, Vector2i(1, 12))
			$Ground.set_cell(xyo+Vector2i(3, 2), 0, Vector2i(1, 12))
			dx += 6
			dy += 2
		
		_ :
			push_error("Wrong chunk ID")
			pass
	return xyo+Vector2i(dx, dy)

func sequencetotiles(sequence, xyo) :
	for i in sequence :
		xyo = generatechunk(i, xyo)
	pass
