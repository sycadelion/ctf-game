class_name MovementComp extends Node



@export var entity: Node3D
# Movement parameters
@export_group("Parameters")
@export var MAX_VELOCITY_AIR: float = 2.0
@export var MAX_VELOCITY_GROUND: float = 4.0
@export var MAX_ACCELERATION_MULTI: float = 10.0
@export var MAX_ACCELERATION_AIR_MULTI: float = 10.0
@export var MAX_ACCELERATION_SPRINT_MULTI: float = 2.0
@export var FRICTION: float = 8.0
@export var FRICTION_AIR: float = 2.1
@export var SPRINT_SPEED: float = 1.5
@export var GRAVITY: float = 15.34
@export var STOP_SPEED: float = 1.5
@export var STOP_SPEED_AIR: float = 1.2
@export var JUMP_IMPULSE_MULTI1: float = 3.2
@export var JUMP_IMPULSE_MULTI2: float = 0.85
var MAX_ACCELERATION: float = MAX_ACCELERATION_MULTI * MAX_VELOCITY_GROUND
var MAX_ACCELERATION_AIR: float = MAX_ACCELERATION_AIR_MULTI * MAX_VELOCITY_GROUND
var MAX_ACCELERATION_SPRINT: float = MAX_ACCELERATION_SPRINT_MULTI * MAX_ACCELERATION
var JUMP_IMPULSE: float = sqrt(JUMP_IMPULSE_MULTI1 * GRAVITY * JUMP_IMPULSE_MULTI2)

var direction: Vector3 = Vector3.ZERO
var wish_jump: bool = false
var wish_sprint: bool = false

func process_input():
	if !is_multiplayer_authority(): 
		return
	direction = Vector3.ZERO
	
	# Movement directions
	if Input.is_action_pressed("Forward"):
		direction -= entity.transform.basis.z
	elif Input.is_action_pressed("Backward"):
		direction += entity.transform.basis.z
	if Input.is_action_pressed("Left"):
		direction -= entity.transform.basis.x
	elif Input.is_action_pressed("Right"):
		direction += entity.transform.basis.x
	
	wish_jump = Input.is_action_just_pressed("Jump")
	if entity.is_on_floor():
		if Input.is_action_pressed("Sprint"):
			wish_sprint = true
	if Input.is_action_just_released("Sprint"):
		wish_sprint = false

func process_movement(delta: float):
	if !is_multiplayer_authority(): 
		return
	# get normalized input direction so diagonal isn't faster
	var wish_dir: Vector3 = direction.normalized()
	
	if entity.is_on_floor():
		if wish_jump:
			entity.velocity.y = JUMP_IMPULSE
			entity.velocity = update_velocity_air(wish_dir, delta)
			wish_jump = false
		else:
			entity.velocity = update_velocity_ground(wish_dir,delta)
	else:
		entity.velocity.y -= GRAVITY * delta
		entity.velocity = update_velocity_air(wish_dir,delta)

	entity.move_and_slide()

func accelerate(wish_dir: Vector3, max_velocity: float, delta: float):
	if !is_multiplayer_authority(): 
		return
	# get our current speed as a projection of velocity onto wish direction
	var current_speed = entity.velocity.dot(wish_dir)
	# how much we accelerate is the difference between max speed and the current speed
	# clamped to between 0 and MAX_ACCELERATION which is intended to stop you from going too fast
	var add_speed: float
	if wish_sprint:
		add_speed = clamp((max_velocity * SPRINT_SPEED) - current_speed,0,MAX_ACCELERATION_SPRINT * delta) \
		if entity.is_on_floor() else clamp((max_velocity) - current_speed,0,MAX_ACCELERATION_AIR * delta) 
	elif not wish_sprint:
		add_speed = clamp(max_velocity - current_speed,0,MAX_ACCELERATION * delta) \
		if entity.is_on_floor() else clamp((max_velocity) - current_speed,0,MAX_ACCELERATION_AIR * delta) 

	return entity.velocity + add_speed * wish_dir

func update_velocity_ground(wish_dir: Vector3,delta: float):
	if !is_multiplayer_authority(): 
		return
	# apply FRICTION when on the ground then accelerate
	var speed = entity.velocity.length()
	
	if speed != 0:
		var control = max(STOP_SPEED, speed)
		var drop = control * FRICTION * delta
		
		# Scale the velocity based on FRICTION
		entity.velocity *= max(speed - drop, 0) / speed

	return accelerate(wish_dir,MAX_VELOCITY_GROUND,delta)

func update_velocity_air(wish_dir: Vector3,delta: float):
	if !is_multiplayer_authority(): 
		return
	# apply FRICTION when on the ground then accelerate
	var speed = entity.velocity.length()
	
	if speed != 0:
		var control = max(STOP_SPEED_AIR, speed)
		var drop = control * FRICTION_AIR * delta
		
		# Scale the velocity based on FRICTION
		entity.velocity *= max(speed - drop, 0) / speed
	# don't apply FRICTION
	return accelerate(wish_dir,MAX_VELOCITY_AIR, delta)
