extends Control

var scenemenu = preload("res://Scenes/Menu.tscn")
var scenelevel = preload("res://Scenes/Level.tscn")
var sceneboss = preload("res://Scenes/Boss Room.tscn")
var sceneplayer = preload("res://Scenes/Player.tscn")

var instancemenu:Node = null
var instancelevel:Node = null
var instanceboss:Node = null
var instanceplayer:Node = null

var runtime
var initialplayerpos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	loadmainmenu()
	
	# Preparing the player
	instanceplayer = sceneplayer.instantiate()
	instanceplayer.settotallife(instanceplayer.maxlife)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("game_pause") :
		if (instancelevel != null and instancelevel.is_inside_tree()) or (instanceboss != null and instanceboss.is_inside_tree()) :
			setpause(!get_tree().paused)
	if not $MusicPlayer.playing :
		$MusicPlayer.play()
	
	runtime = Time.get_ticks_msec()-Globals.runstart
	$"HUD Layer/Label".text = "%sm%ss.%s"%[int(runtime / (1000*60)), int(runtime / 1000 % 60), runtime % 1000]

func resumegame() :
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
	if instanceboss != null and instanceboss.is_inside_tree() :
		$Pausable.remove_child(instanceboss)
	if instanceplayer != null and instanceplayer.is_inside_tree() :
		$Pausable.remove_child(instanceplayer)
		instanceplayer.queue_free()
		instanceplayer = sceneplayer.instantiate()
	#Globals.playertotallife = Globals.playermaxlife
	loadlevel(0)
	setpause(0)
	
func loadmainmenu() :
	if instancelevel != null and instancelevel.is_inside_tree() :
		$Pausable.remove_child(instancelevel)
	if instanceplayer != null and instanceplayer.is_inside_tree() :
		$Pausable.remove_child(instanceplayer)
	$"HUD Layer".visible = false
	instancemenu = scenemenu.instantiate()
	$Pausable.add_child(instancemenu)
	instancemenu.connect("btnplay", loadlevel)
	instancemenu.connect("btnquit", quitgame)
	var sound = load("res://Art/Audio/Musics/menu music.mp3")
	$MusicPlayer.stream = sound
	$MusicPlayer.play()
	
func loadlevel(num) :
	if instancemenu != null and instancemenu.is_inside_tree() :
		$Pausable.remove_child(instancemenu)
	if not instanceplayer.is_inside_tree() :
		instanceplayer = sceneplayer.instantiate()
	instancelevel = scenelevel.instantiate()
	$Pausable.add_child(instancelevel)
	initialplayerpos = Vector2(45, 16*instancelevel.xyo[1]-25)
	instanceplayer.position = initialplayerpos
	instanceplayer.connect("dead", resetplayer)
	$Pausable.add_child(instanceplayer)
	$"HUD Layer".visible = true
	
	instancelevel.connect("playerreachedend", loadbossroom)
	
	var sound = load("res://Art/Audio/Musics/level music.mp3")
	$MusicPlayer.stream = sound
	$MusicPlayer.play()
	
func loadbossroom() :
	if instancemenu != null and instancemenu.is_inside_tree() :
		$Pausable.remove_child(instancemenu)
	if instancelevel != null and instancelevel.is_inside_tree() :
		instancelevel.queue_free()
		$Pausable.remove_child(instancelevel)
	instanceboss = sceneboss.instantiate()
	$Pausable.add_child(instanceboss)
	initialplayerpos = Vector2(45, 16*instancelevel.xyo[1]-150)
	instanceplayer.position = initialplayerpos
	$"HUD Layer".visible = true
	
	var sound = load("res://Art/Audio/Musics/level music.mp3")
	$MusicPlayer.stream = sound
	$MusicPlayer.play()
	
func resetplayer() -> void:
	if instanceboss != null and instanceboss.is_inside_tree() :
		$Pausable.remove_child(instanceboss)
		$Pausable.remove_child(instanceplayer)
		instanceboss.queue_free()
		instanceplayer.queue_free()
		loadmainmenu()
	elif instanceplayer != null :
		instanceplayer.rebirth(initialplayerpos)
	
func quitgame() :
	get_tree().quit()
