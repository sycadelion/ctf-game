extends CharacterBody2D

const SPEED = 300.0

@export var steam_id: int = 0

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	if steam_id == 0:
		steam_id = Steamworks.steam_id

func _ready() -> void:
	if Networking.lobby_id > 0 and steam_id > 0:
		update_vars.rpc(steam_id)
		$Sprite2D.texture = Steamworks.get_avatar_image(steam_id)
	if is_multiplayer_authority():
			%Camera2D.enabled = true

func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority(): 
		return
	if event.is_action_pressed("test"):
		%Camera2D.enabled = true

func _physics_process(_delta: float) -> void:
	if !is_multiplayer_authority(): 
		return
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left","right","forward","backward")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x,0,SPEED)
		velocity.y = move_toward(velocity.y,0,SPEED)

	move_and_slide()

@rpc("authority","call_local")
func update_vars(this_steam_id: int):
	steam_id = this_steam_id

func _exit_tree() -> void:
	if is_multiplayer_authority():
		%MultiplayerSynchronizer.public_visibility = false
