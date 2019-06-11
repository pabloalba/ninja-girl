extends Node2D

const MODE_RUNNING = 0
const MODE_DYING = 1
const MODE_BOUNCING = 2

var mode
var looking_right = true
var bouncing_time = 0
var dying_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	mode = MODE_RUNNING
	looking_right = true
	
func _process(delta):
	if mode == MODE_BOUNCING:
		bouncing_time += delta
	elif mode == MODE_DYING:
		dying_time += delta
	
func look_right():
	get_node("AnimatedSprite").flip_h = false
	looking_right = true

func look_left():
	get_node("AnimatedSprite").flip_h = true	
	looking_right = false

func go_dying():
	if mode == MODE_RUNNING:
		mode = MODE_DYING
		dying_time = 0
		get_node("AnimatedSprite").play("dying")
	
func go_bouncing():
	if mode == MODE_RUNNING:
		mode = MODE_BOUNCING
		bouncing_time = 0

func go_running():
	mode = MODE_RUNNING