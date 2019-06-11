extends Node2D

const NINJA_SPEED = 1000
var ZOMBIE_SPEED = 300
const ATTACKING_TIME = 0.4
const COLLISION_MARGIN = 100
const MAX_ZOMBIE_BOUNCING_TIME = 0.25

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
	process_zombies(delta)
	
func process_zombies(delta):
	for zombie in zombies:
		process_zombie(zombie, delta)
		
func process_zombie(zombie, delta):
	if zombie.mode == zombie.MODE_BOUNCING:
		if zombie.bouncing_time >= MAX_ZOMBIE_BOUNCING_TIME:
			zombie.go_running()
	
	if abs (zombie.position.x - ninja.position.x) < 2000:
		if zombie.position.x < ninja.position.x:
			zombie.look_right()
			if zombie.mode != zombie.MODE_BOUNCING:
				zombie.position.x += delta * ZOMBIE_SPEED
			else:
				zombie.position.x -= delta * (ZOMBIE_SPEED * 2)
		if zombie.position.x > ninja.position.x:
			zombie.look_left()
			if zombie.mode != zombie.MODE_BOUNCING:
				zombie.position.x -= delta * ZOMBIE_SPEED
			else:
				zombie.position.x += delta * (ZOMBIE_SPEED * 2)
			
		if check_zombie_collision(zombie):
			hit_ninja(zombie)
			
func check_zombie_collision(zombie):
	return abs(zombie.position.x - ninja.position.x) < COLLISION_MARGIN
	
func hit_ninja(zombie):
	zombie.go_bouncing()
	
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