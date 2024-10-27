extends Node

func weightedchoice(valuesspace, weights) :
	var r = randf()
	var w = 0
	var i = 0
	while w <= r :
		w += weights[i]
		i+=1
	return valuesspace[i-1]

func test() :
	print("test of weightedchoice()")
	var x
	var w
	var o
	x = [0,1,2,3]
	w = [0.25, 0.25, 0.25, 0.25]
	o = [0, 0, 0, 0]
	for i in range(15000) :
		o[weightedchoice(x, w)] += 1
	print(o)
	w = [0.05, 0.45, 0.0, 0.5]
	o = [0, 0, 0, 0]
	for i in range(15000) :
		o[weightedchoice(x, w)] += 1
	print(o)
	print("Done")
