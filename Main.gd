extends Node2D

const NINJA_SPEED = 1000
const ATTACKING_TIME = 0.4
var ninja
var remaining_attacking_time = 0
var zombies

# Called when the node enters the scene tree for the first time.
func _ready():
	zombies = []
	ninja = get_node("Ninja")
	add_zombie(800, 200)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_player_input(delta)
	
func add_zombie(x, y):
	var zombie = load("res://Zombie.tscn").instance()
	zombie.position.x = x
	zombie.position.y = y
	zombies.append(zombie)
	add_child(zombie)

func process_player_input(delta):
	if ninja.mode == ninja.MODE_ATTACKING:
		remaining_attacking_time -= delta
		if remaining_attacking_time <=0 :
			ninja.go_idle()
	else:
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
		elif Input.is_action_pressed("ui_accept"):
				ninja.go_attacking()
				remaining_attacking_time = ATTACKING_TIME
		else:
			ninja.go_idle()