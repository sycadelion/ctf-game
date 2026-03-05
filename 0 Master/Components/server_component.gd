class_name server_comp extends Node

signal started_game
signal updated_scores
const BLANK_PLAYER = {"steam_name": "", "steam_id": 0}

var player_ids: Array = []
var game_started: bool = false
@onready var start_timer: Timer = $start_timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.server_component = self
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	started_game.connect(_start_game)
	updated_scores.connect(_update_scores)
	if Networking.current_online_mode == Networking.online_mode.STEAM:
		player_ids.append(multiplayer.get_unique_id())
		Global.lobby.spawn_lobby_member_listing.rpc(Networking.lobby_members[0],multiplayer.get_unique_id())
	elif Networking.current_online_mode == Networking.online_mode.ENET:
		player_ids.append(multiplayer.get_unique_id())
		Global.lobby.spawn_lobby_member_listing.rpc(BLANK_PLAYER,multiplayer.get_unique_id())

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Test"):
		updated_scores.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.lobby.current_level:
		if start_timer.time_left > 0:
			Global.lobby.current_level.update_timer.rpc(start_timer.time_left)

func _on_player_connected(id: int):
	Global.lobby.clear_lobby_member_listing.rpc()
	player_ids.append(id)
	clientmanager.update_slot.rpc_id(id,player_ids.find(id))
	clientmanager.update_player_count.rpc(player_ids.size())
	if Networking.current_online_mode == Networking.online_mode.STEAM:
		Networking.get_lobby_members()
		for i in player_ids:
			Global.lobby.spawn_lobby_member_listing.rpc(Networking.lobby_members[player_ids.find(i)],i)
	elif Networking.current_online_mode == Networking.online_mode.ENET:
		for i in player_ids:
			Global.lobby.spawn_lobby_member_listing.rpc(BLANK_PLAYER,i)

func _on_player_disconnected(_id: int):
	pass

func _exit_tree() -> void:
	Global.server_component = null

func _start_game():
	print_debug("starting")
	start_timer.start()

func _on_start_timer_timeout() -> void:
	Global.lobby.current_level.hide_timer.rpc()
	Global.lobby.spawn_players.rpc(player_ids)

func _update_scores():
	GameManager.party_list_node.update_scores.rpc(0,5)
