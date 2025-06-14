class_name Player
extends CharacterBody2D


@export var keyboard_input : bool = false
@export var controller_input : bool = true
var device_id : int = -1
#region physics variables
@export_group("Walk")
@export var walk_max_speed : float = 250
@export var walk_accel : float = 500
var current_accel : float = walk_accel
var walk_direction : float = 0 #1, -1, or 0

@export var walk_accel_time : float = .025
@export var set_walk_accel_from_time : bool = true
@export_group("Jump")
@export var max_jump_height : float = 200
@export var set_max_jump_time_from_max_jump_height : bool = false
var max_jump_time : float = .3
@export var jump_accel : float = 800
@export var dynamic_jumping : bool = true
@export var dynamic_jump_speed : float = 500
var jump_this_frame : bool = false
var jumping : bool = false
var dynamic_jump_time_counter : float = 0

@export_group("Friction")
@export var ground_slow_down_time : float = .1
@export var set_ground_friction_from_slow_down_time : bool = true

@export var air_slow_down_time : float = .5
@export var set_air_friction_from_slow_down_time : bool = true

@export var ground_friction : float = 2500
@export var air_friction : float = 0
var current_friction : float = ground_friction

@export_group("Gravity")
@export var gravity_accel : float = 2000
#endregion 

var starting_health : float = 100
var health = starting_health:
	set(v):
		if v <= 0:
			health = 0
			die()
		else:
			health = v


func _ready() -> void:
	add_to_group("damagable")
	if set_ground_friction_from_slow_down_time:
		#250 px/sec 250 px/sec / 1 sec = 250 px / sec /sec
		ground_friction = walk_max_speed / ground_slow_down_time
		print("ground friction: ", ground_friction)
	if set_air_friction_from_slow_down_time:
		air_friction = walk_max_speed / air_slow_down_time
		print("air friction: ", air_friction)
	if set_walk_accel_from_time:
		walk_accel = walk_max_speed / walk_accel_time
		print("walk accel ", walk_accel)
	#set jump time from jump height and jump speed
	#px / (px/sec) = sec
	if set_max_jump_time_from_max_jump_height:
		var float_time : float = dynamic_jump_speed / gravity_accel
		var float_distance : float = float_time * dynamic_jump_speed / 2
		max_jump_time = (max_jump_height - float_distance) / dynamic_jump_speed
		print("jump time: ", max_jump_time)


func _physics_process(delta: float) -> void:
	get_input()
	#apply gravity
	if is_on_floor():
		velocity.y = 0
	else:
		if not (dynamic_jumping and jumping):
			velocity.y += gravity_accel * delta
	
	#apply friction
	if walk_direction == 0:
		if is_on_floor():
			current_friction = ground_friction
		else:
			current_friction = air_friction
		var v = abs(velocity.x)
		if v > 0:
			v -= current_friction * delta
			v = max(v, 0)
			velocity.x = sign(velocity.x) * v 
		
	#jump
	if dynamic_jumping:
		if jumping:
			velocity.y = -dynamic_jump_speed
			dynamic_jump_time_counter += delta
			if dynamic_jump_time_counter > max_jump_time or is_on_ceiling():
				quit_jumping()
	else:
		if jump_this_frame:
			velocity.y -= jump_accel
		
	#walk
	var this_walk_accel : float = walk_direction * walk_accel * delta
	if abs(velocity.x + this_walk_accel) <= walk_max_speed: #if accelerating doesnt exceed max speed, accelerate
		velocity.x += this_walk_accel
	elif abs(velocity.x) < walk_max_speed: #if accelerating does exceed max speed but player hasnt reached max speed
		velocity.x = walk_max_speed * sign(walk_direction) #reach max speed
		
	
	move_and_slide()
	handle_visuals()
	#reset variables
	jump_this_frame = false
	walk_direction = 0
	

func handle_visuals():
	pass
	
func walk_right() -> void:
	walk_direction += 1
	if walk_direction != 0:
		walk_direction = sign(walk_direction)
	
	
func walk_left() -> void:
	walk_direction += -1
	if walk_direction != 0:
		walk_direction = sign(walk_direction)
	
	
func jump() -> void:
	if can_jump():
		if dynamic_jumping:
			jumping = true
			dynamic_jump_time_counter = 0
		else:
			jump_this_frame = true
		
		
func quit_jumping() -> void:
	jumping = false
		
		
func can_jump() -> bool:
	return is_on_floor()
	

func dash():
	pass

func get_input() -> void:

	if keyboard_input:
		if Input.is_action_just_pressed("jump"):
			jump()
		if Input.is_action_just_released("jump"):
			quit_jumping()
		if Input.is_action_pressed("walk_left"):
			walk_left()
		if Input.is_action_pressed("walk_right"):
			walk_right()
		if Input.is_action_just_pressed("dash"):
			dash()
	if controller_input:
		if Input.get_joy_axis(device_id, JOY_AXIS_LEFT_X) > 0.2:
			walk_right()
		elif Input.get_joy_axis(device_id, JOY_AXIS_LEFT_X) < -0.2:
			walk_left()
			
			
func _input(event : InputEvent) -> void:
	if event.device == device_id and controller_input:
		if event.is_action_pressed("jump"):
			jump()
		if event.is_action_released("jump"):
			quit_jumping()

	

func spam():
	pass

func sig():
	pass

func special():
	pass

func block():
	pass

func take_damage(dmg : float) -> void:
	health -= dmg

func die() -> void:
	queue_free()
