class_name server_comp extends Node
const BLANK_PLAYER = {"steam_name": "", "steam_id": 0}
var player_count: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.server_component = self
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	if Networking.current_online_mode == Networking.online_mode.STEAM:
		Global.lobby.spawn_lobby_member_listing.rpc(Networking.lobby_members[0])
	elif Networking.current_online_mode == Networking.online_mode.ENET:
		player_count += 1
		Global.lobby.spawn_lobby_member_listing.rpc(BLANK_PLAYER)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_connected(id: int):
	Global.lobby.clear_lobby_member_listing.rpc()
	player_count += 1
	if Networking.current_online_mode == Networking.online_mode.STEAM:
		Networking.get_lobby_members()
		for i in Networking.lobby_members:
			Global.lobby.spawn_lobby_member_listing.rpc(i)
	elif Networking.current_online_mode == Networking.online_mode.ENET:
		for i in player_count:
			Global.lobby.spawn_lobby_member_listing.rpc(BLANK_PLAYER)

func _on_player_disconnected(id: int):
	pass

func _exit_tree() -> void:
	Global.server_component = null
