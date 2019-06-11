extends Node2D

const MODE_IDLE = 0
const MODE_RUNNING = 1
const MODE_ATTACKING = 3

var mode
var looking_right
var attacking_time = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	mode = MODE_IDLE
	looking_right = true
	
func _process(delta):
	if mode == MODE_ATTACKING:
		attacking_time += delta

func look_right():
	get_node("AnimatedSprite").flip_h = false
	looking_right = true

func look_left():
	get_node("AnimatedSprite").flip_h = true	
	looking_right = false

func go_idle():
	mode = MODE_IDLE
	get_node("AnimatedSprite").play("idle")
		
func go_attacking():
	if mode == MODE_IDLE:
		mode = MODE_ATTACKING
		attacking_time = 0
		get_node("AnimatedSprite").play("attack")
	

func go_running():
	if mode == MODE_IDLE:
		mode = MODE_RUNNING
		get_node("AnimatedSprite").play("running")