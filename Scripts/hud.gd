extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Player Healthbar/Label".text = "Life"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"Player Healthbar".percentfill = Globals.playerlife/Globals.playertotallife
	$"Player Healthbar".setlength(Globals.playertotallife*2)
	#print($"Player Healthbar".length, " ", $"Player Healthbar".percentfill)