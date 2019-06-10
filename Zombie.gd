extends Node2D

const MODE_RUNNING = 0
const MODE_DYING = 1

var mode
var looking_right


# Called when the node enters the scene tree for the first time.
func _ready():
	mode = MODE_RUNNING
	looking_right = true

func look_right():
	get_node("AnimatedSprite").flip_h = false
	looking_right = true

func look_left():
	get_node("AnimatedSprite").flip_h = true	
	looking_right = false

func go_dying():
	if mode == MODE_RUNNING:
		mode = MODE_DYING
		get_node("AnimatedSprite").play("dying")
	
