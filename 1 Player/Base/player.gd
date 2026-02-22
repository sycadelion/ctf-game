class_name Player extends CharacterBody3D

# Player State Enums
enum Effect_state_modes {DEFAULT,CONTROLLED,PAUSED}
enum Player_state_modes {IDLE,AIR,WALK,SPRINT,CROUCHIDLE,CROUCHMOVE,DEAD}
enum Player_Arm_State_modes {IDLE,AIR,MOVE,CROUCH,AIM,INTERRUPT}

@export var steam_id: int = 0
@export var spawn_loc: Vector3
# Components
@export_group("Components")
@export var ears_comp: PackedScene
@export var health_comp: HealthComp
@export var audio_comp: AudioPlayerComp
@export var movement_comp: MovementComp
@export_group("State Machines")
@export var movement_state: StateMachine
@export var skill_state: StateMachine

var public_vis: bool = true
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
@onready var anim_player: AnimationPlayer = $AnimationPlayer_Body
@onready var anim_player_audio: AnimationPlayer = $AnimationPlayer_Audio
@onready var synchronizer: MultiplayerSynchronizer = %MultiplayerSynchronizer
@onready var player_head: Node3D = $Head
@onready var camera_3d: Camera3D = %Camera3D
@onready var respawn_timer: Timer = $Respawn_timer

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	if steam_id == 0:
		steam_id = Steamworks.steam_id

func _ready() -> void:
	position = Global.lobby.current_level.spawn_points.pick_random().global_position
	if Networking.lobby_id > 0 and steam_id > 0:
		update_vars.rpc(steam_id)
	if is_multiplayer_authority():
		camera_3d.current = true
		%UX.show()
		player_head.call_deferred("add_child",ears_comp.instantiate())
		if get_window().has_focus():
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
	if event.is_action_pressed("Test"):
		randomize()
		$"UX/Party List".add_party_listing(Color(randf_range(0.5,1), randf_range(0.5,1), randf_range(0.5,1), randf_range(0.2,1)),  32)
		#get_tree().get_first_node_in_group("SkillUltimate").changed_enabled(true)

func _process(_delta: float) -> void:
	if !is_multiplayer_authority(): 
		return
	if not public_vis:
		%MultiplayerSynchronizer.public_visibility = false
	%test_label.text = str($Skill_State.current_state)


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
	is_dead = false
