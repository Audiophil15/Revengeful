extends Sprite2D

signal playerentered

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_fond_body_entered(body: Node2D) -> void:
	if body.get_instance_id() == Globals.PlayerID :
		emit_signal("playerentered")
