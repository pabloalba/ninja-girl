extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.is_player_win:
		get_node("Label").set_text("You win!")
		get_node("Label").add_color_override("font_color", Color(0,1,0))
	else:
		get_node("Label").set_text("You lose!")
		get_node("Label").add_color_override("font_color", Color(1,0,0))
