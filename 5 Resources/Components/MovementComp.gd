class_name MovementComp extends Node

# Movement
const MAX_VELOCITY_AIR: float = 0.6
const MAX_VELOCITY_GROUND: float = 4.0
const MAX_ACCELERATION: float = 10 * MAX_VELOCITY_GROUND
const MAX_ACCELERATION_AIR: float = 5 * MAX_VELOCITY_GROUND
const MAX_ACCELERATION_SPRINT: float = MAX_ACCELERATION * 2
const FRICTION: float = 8.0
const FRICTION_AIR: float = 2.0
const SPRINT_SPEED: float = 1.5
const GRAVITY: float = 15.34
const STOP_SPEED: float = 1.5
const JUMP_IMPULSE: float = sqrt(4 * GRAVITY * 0.85)

@export var entity: Node3D

var direction: Vector3 = Vector3.ZERO
var wish_jump: bool = false
var wish_sprint: bool = false

func process_input():
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
	# apply FRICTION when on the ground then accelerate
	var speed = entity.velocity.length()
	
	if speed != 0:
		var control = max(STOP_SPEED, speed)
		var drop = control * FRICTION * delta
		
		# Scale the velocity based on FRICTION
		entity.velocity *= max(speed - drop, 0) / speed

	return accelerate(wish_dir,MAX_VELOCITY_GROUND,delta)

func update_velocity_air(wish_dir: Vector3,delta: float):
	# apply FRICTION when on the ground then accelerate
	var speed = entity.velocity.length()
	
	if speed != 0:
		var control = max(STOP_SPEED, speed)
		var drop = control * FRICTION_AIR * delta
		
		# Scale the velocity based on FRICTION
		entity.velocity *= max(speed - drop, 0) / speed
	# don't apply FRICTION
	return accelerate(wish_dir,MAX_VELOCITY_AIR, delta)
