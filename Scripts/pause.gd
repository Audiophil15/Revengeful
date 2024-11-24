extends Control

signal btnplay
signal btnreset
signal btnquit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_quit_button_pressed() -> void:
	emit_signal("btnquit")


func _on_start_button_pressed() -> void:
	emit_signal("btnplay")


func _on_restart_entire_game_pressed() -> void:
	emit_signal("btnreset")
