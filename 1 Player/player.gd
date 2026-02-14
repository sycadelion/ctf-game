class_name Player extends CharacterBody3D

# Movement
const MAX_VELOCITY_AIR: float = 0.6
const MAX_VELOCITY_GROUND: float = 6.0
const MAX_ACCELERATION: float = 10 * MAX_VELOCITY_GROUND
const GRAVITY: float = 15.34
const STOP_SPEED: float = 1.5
const JUMP_IMPULSE: float = sqrt(2 * GRAVITY * 0.85)

# Player State Enums
enum Effect_state_modes {DEFAULT,CONTROLLED,PAUSED}
enum Player_state_modes {IDLE,AIR,WALK,SPRINT,CROUCHIDLE,CROUCHMOVE,DEAD}
enum Player_Arm_State_modes {IDLE,AIR,MOVE,CROUCH,AIM,INTERRUPT}

@export var steam_id: int = 0
@export var spawn_loc: Vector3
# Components
@export_group("Components")
@export var health_comp: HealthComp
@export var audio_comp: AudioEntityComp
@export var movement_comp: MovementComp

var public_vis: bool = true
var jump_timer: float = 0
var jump_multi: int = 1
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction: Vector3 = Vector3.ZERO
var wish_jump: bool = false
var friction: float = 8
# Player States
var current_player_effect_state: Effect_state_modes = Effect_state_modes.DEFAULT
var current_player_state: Player_state_modes = Player_state_modes.IDLE
var current_player_arm_state: Player_Arm_State_modes = Player_Arm_State_modes.IDLE
var is_dead: bool = false
# Look sensitivities
var mouse_sensitivity: float = 0.5
var mouse_aim_sensitivity: float = 0.002
var controller_sensitivity: float = 0.06
var controller_aim_sensitivity: float = controller_sensitivity / 2
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var anim_player_audio: AnimationPlayer = $AnimationPlayer_audio
@onready var synchronizer: MultiplayerSynchronizer = %MultiplayerSynchronizer
@onready var player_head: Node3D = $head
@onready var camera_3d: Camera3D = %Camera3D
@onready var respawn_timer: Timer = $Respawn_timer
@onready var state_label: Label = $PanelContainer/MarginContainer/stateLabel

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	if steam_id == 0:
		steam_id = Steamworks.steam_id

func _ready() -> void:
	position = Global.lobby.current_level.spawn_points.pick_random().global_position
	print_debug(str(position))
	if Networking.lobby_id > 0 and steam_id > 0:
		update_vars.rpc(steam_id)
	if is_multiplayer_authority():
		camera_3d.current = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority(): 
		return
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_handle_camera_rotation(event)
	if event.is_action_pressed("Jump") and is_on_floor():
		pass
	if event.is_action_pressed("Menu"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(_delta: float) -> void:
	if !is_multiplayer_authority(): 
		return
	state_label.text = "State: %s" % Player_state_modes.find_key(current_player_state)
	if not public_vis:
		%MultiplayerSynchronizer.public_visibility = false

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): 
		return
	if not is_dead:
		apply_controller_rotation()
		movement_comp.process_input()
		movement_comp.process_movement(delta)
	else:
		Global.lobby.current_level.timer_label.text = "Respawning in: %s" % roundi(respawn_timer.time_left)
	
	if position.y <= -20 and not is_dead:
		death()


func is_player() -> bool:
	return true

func death():
	is_dead = true
	self.visible = false
	camera_3d.current = false
	state_label.visible = false
	position = Global.lobby.current_level.spawn_points.pick_random().global_position
	respawn_timer.start()
	velocity = Vector3.ZERO
	Global.lobby.current_level.timer_label.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _handle_camera_rotation(event: InputEvent):
	rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
	player_head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
	
	# Stop head from rotating to far up or down
	player_head.rotation.x = clamp(player_head.rotation.x, deg_to_rad(-60),deg_to_rad(90))

func apply_controller_rotation() -> void:
	var axis_vector: Vector2 = Vector2.ZERO
	axis_vector.x = Input.get_action_strength("Look_left") - Input.get_action_strength("Look_right")
	axis_vector.y = Input.get_action_strength("Look_down") - Input.get_action_strength("Look_up")
	
	if InputEventJoypadMotion:
		rotate_y(axis_vector.x * controller_sensitivity)
		player_head.rotate_x(-axis_vector.y * controller_sensitivity)
		player_head.rotation.x = clamp(player_head.rotation.x,-PI/2,PI/2)


@rpc("authority","call_local")
func update_vars(this_steam_id: int):
	steam_id = this_steam_id

@rpc("any_peer","call_local")
func kill_sync():
	synchronizer.public_visibility = false
	await get_tree().create_timer(0.1).timeout
	despawn.rpc_id(1)

@rpc("any_peer","call_local")
func despawn():
	if get_tree().get_multiplayer().get_unique_id() == 1:
		queue_free()

func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_respawn_timer_timeout() -> void:
	Global.lobby.current_level.timer_label.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	self.visible = true
	camera_3d.current = true
	state_label.visible = true
	is_dead = false
