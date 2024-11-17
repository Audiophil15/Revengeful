extends Control

var scenemenu = preload("res://Scenes/Menu.tscn")
var scenelevel = preload("res://Scenes/Level.tscn")

var instancemenu:Node = null
var instancelevel:Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadmainmenu()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("game_pause") :
		if instancelevel != null and instancelevel.is_inside_tree() :
			get_tree().paused = !get_tree().paused
			if get_tree().paused :
				$Pausebg.visible = true
			else :
				$Pausebg.visible = false

func loadmainmenu() :
	if instancelevel != null :
		remove_child(instancelevel)
	instancemenu = scenemenu.instantiate()
	$Pausable.add_child(instancemenu)
	instancemenu.connect("btnplay", loadlevel)
	instancemenu.connect("btnquit", quitgame)
	
func loadlevel(num) :
	if instancemenu != null :
		remove_child(instancemenu)
	instancelevel = scenelevel.instantiate()
	$Pausable.add_child(instancelevel)
	instancelevel.connect("tomainmenu", loadmainmenu)
	
func quitgame() :
	get_tree().quit()
