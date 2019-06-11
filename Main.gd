extends Node2D

const NINJA_SPEED = 1000
var ZOMBIE_SPEED = 300
const ATTACKING_TIME = 0.4
const COLLISION_MARGIN = 100
const COLLISION_MARGIN_SWORD = 200
const MAX_ZOMBIE_BOUNCING_TIME = 0.25
const MAX_ZOMBIE_DYING_TIME = 3
var FIRST_FLOOR_Y = 190
var GROUND_FLOOR_Y = 445

var ninja
var zombies
var ninja_is_in_first_floor = true

# Called when the node enters the scene tree for the first time.
func _ready():
	zombies = []
	ninja = get_node("Ninja")
	add_zombie(1500, FIRST_FLOOR_Y)
	add_zombie(2800, FIRST_FLOOR_Y)
	add_zombie(4000, FIRST_FLOOR_Y)
	add_zombie(0, GROUND_FLOOR_Y)
	add_zombie(3000, GROUND_FLOOR_Y)
	add_zombie(6000, GROUND_FLOOR_Y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_player_input(delta)
	process_ninja(delta)	
	process_zombies(delta)
	
func process_zombies(delta):
	for zombie in zombies:
		process_zombie(zombie, delta)
		
func process_zombie(zombie, delta):
	if zombie.mode == zombie.MODE_DYING:
		process_dying_zombie(zombie, delta)
	else:
		process_undead_zombie(zombie, delta)
		
func process_dying_zombie(zombie, delta):	
	if zombie.dying_time > MAX_ZOMBIE_DYING_TIME:
		remove_child(zombie)
		zombies.erase(zombie)

func process_undead_zombie(zombie, delta):
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
			
		if (zombie.looking_right != ninja.looking_right and 
			ninja.mode == ninja.MODE_ATTACKING and
			check_zombie_collision(zombie, COLLISION_MARGIN_SWORD)):
				kill_zombie(zombie)
		elif check_zombie_collision(zombie, COLLISION_MARGIN):
			hit_ninja(zombie)
			
func check_zombie_collision(zombie, collision_margin):
	return (abs(zombie.position.y - ninja.position.y) < collision_margin &&
		abs(zombie.position.x - ninja.position.x) < collision_margin)
		
	
func hit_ninja(zombie):
	zombie.go_bouncing()
	
func kill_zombie(zombie):
	zombie.go_dying()
	
func add_zombie(x, y):
	var zombie = load("res://Zombie.tscn").instance()
	zombie.position.x = x
	zombie.position.y = y + 10 # Little hack for visual improvement
	zombies.append(zombie)
	add_child(zombie)

func process_player_input(delta):
	if ninja.mode != ninja.MODE_ATTACKING && ninja.mode != ninja.MODE_JUMPING:
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
		elif Input.is_action_pressed("ui_up"):		
			ninja.go_jumping()
		elif Input.is_action_pressed("ui_down"):		
			ninja.go_jumping()
		else:
			ninja.go_idle()
			
func process_ninja(delta):
	if ninja.mode == ninja.MODE_ATTACKING && ninja.attacking_time > ATTACKING_TIME:
		ninja.go_idle()
	if ninja.mode == ninja.MODE_JUMPING:
		if ninja_is_in_first_floor:
			ninja.position.y += delta * NINJA_SPEED
			if ninja.position.y >= GROUND_FLOOR_Y:
				ninja.position.y = GROUND_FLOOR_Y
				ninja_is_in_first_floor = false
				ninja.go_idle()
		else:
			ninja.position.y -= delta * NINJA_SPEED
			if ninja.position.y <= FIRST_FLOOR_Y:
				ninja.position.y = FIRST_FLOOR_Y
				ninja_is_in_first_floor = true
				ninja.go_idle()