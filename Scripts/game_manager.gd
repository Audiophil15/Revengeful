extends Control

var scenemenu = preload("res://Scenes/Menu.tscn")
var scenelevel = preload("res://Scenes/Level.tscn")

var instancemenu:Node = null
var instancelevel:Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	loadmainmenu()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("game_pause") :
		if instancelevel != null and instancelevel.is_inside_tree() :
			setpause(!get_tree().paused)

func resumegame() :
	print("should resume")
	setpause(0)

func setpause(ouinon) :
	get_tree().paused = ouinon
	if ouinon :
		$"Pause Layer".visible = true
	else :
		$"Pause Layer".visible = false

func resetgame() :
	if instancelevel != null and instancelevel.is_inside_tree() :
		$Pausable.remove_child(instancelevel)
	#Globals.playertotallife = Globals.playermaxlife
	loadlevel(0)
	setpause(0)
	
func loadmainmenu() :
	if instancelevel != null and instancelevel.is_inside_tree() :
		$Pausable.remove_child(instancelevel)
	$"HUD Layer".visible = false
	instancemenu = scenemenu.instantiate()
	$Pausable.add_child(instancemenu)
	instancemenu.connect("btnplay", loadlevel)
	instancemenu.connect("btnquit", quitgame)
	
func loadlevel(num) :
	if instancemenu != null and instancemenu.is_inside_tree() :
		$Pausable.remove_child(instancemenu)
	instancelevel = scenelevel.instantiate()
	$Pausable.add_child(instancelevel)
	$"HUD Layer".visible = true
	
	instancelevel.connect("tomainmenu", loadmainmenu)
	
func quitgame() :
	get_tree().quit()
