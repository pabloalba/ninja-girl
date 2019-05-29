extends Node2D

const NINJA_SPEED = 1000
var ninja

# Called when the node enters the scene tree for the first time.
func _ready():
	ninja = get_node("Ninja")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_player_input(delta)

func process_player_input(delta):
	if Input.is_action_pressed("ui_right"):
		ninja.position.x += delta * NINJA_SPEED
		ninja.look_right()
		ninja.go_running()
		if ninja.position.x >=9400:
			ninja.position.x = 9400
	elif Input.is_action_pressed("ui_left"):
		ninja.position.x -= delta * NINJA_SPEED
		ninja.look_left()
		ninja.go_running()
		if ninja.position.x <=0:
			ninja.position.x = 0
	else:
		ninja.go_idle()