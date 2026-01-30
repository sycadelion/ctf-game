extends Node

signal hosted
const PACKET_READ_LIMIT: int = 32
const PORT = 1027
enum online_mode {STEAM,ENET}

var username: String = "failed" # fallback username
var is_host: bool = false
var is_joining: bool = false
var current_online_mode: online_mode = online_mode.STEAM
var peer
var host_ip: String
var lobby_id: int = 0
var lobby_members: Array = []
var lobby_members_max: int = 10
var lobby_vote_kick: bool = false
var lobby_type: Steam.LobbyType = Steam.LobbyType.LOBBY_TYPE_FRIENDS_ONLY


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_environment("USER"):
		username = OS.get_environment("USER")
	elif OS.has_environment("USERNAME"):
		username = OS.get_environment("USERNAME")
	else:
		username = "PLAYER"

	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.join_requested.connect(_on_join_requested)
	Steam.p2p_session_request.connect(_on_p2p_session_request)

func _process(_delta: float) -> void:
	if lobby_id > 0:
		read_all_p2p_packets()

func reset_lobby_data() -> void:
	if multiplayer.multiplayer_peer:
		if multiplayer.multiplayer_peer.get_connection_status() == 0:
			lobby_id = 0
			multiplayer.multiplayer_peer = null
			peer = null
			Global.lobby = null
			is_host = false

func create_lobby():
	if current_online_mode == online_mode.ENET:
		is_host = true
		peer = ENetMultiplayerPeer.new()
		peer.create_server(PORT,10)
		
		multiplayer.multiplayer_peer = peer
		hosted.emit()
	else:
		if lobby_id == 0:
			peer = SteamMultiplayerPeer.new()
			Steam.createLobby(lobby_type,lobby_members_max)
	is_host = true

func join_lobby(this_lobby_id: int = 0, ip_address: String = "127.0.0.1"):
	is_joining = true
	if this_lobby_id == 0:
		current_online_mode = online_mode.ENET
		peer = ENetMultiplayerPeer.new()
		peer.create_client(ip_address,PORT)
		multiplayer.multiplayer_peer = peer
		hosted.emit()
	elif this_lobby_id > 0:
		current_online_mode = online_mode.STEAM
		peer = SteamMultiplayerPeer.new()
		Steam.joinLobby(this_lobby_id)
		multiplayer.multiplayer_peer = peer


func get_lobby_members():
	lobby_members.clear()
	
	var num_of_lobby_members: int = Steam.getNumLobbyMembers(lobby_id)
	
	for member in range(0,num_of_lobby_members):
		var member_steam_id: int = Steam.getLobbyMemberByIndex(lobby_id,member)
		var member_steam_name: String = Steam.getFriendPersonaName(member_steam_id)
		lobby_members.append({"steam_id": member_steam_id, "steam_name": member_steam_name})
	print("Lobby members: ", str(lobby_members))

func _on_lobby_created(connect: int, this_lobby_id: int):
	if connect == 1:
		lobby_id = this_lobby_id
		
		Steam.setLobbyJoinable(lobby_id,true)
		Steam.setLobbyData(lobby_id,"name","Syca's test lobby")
		
		var set_relay: bool = Steam.allowP2PPacketRelay(true)
		peer = SteamMultiplayerPeer.new()
		peer.server_relay = true
		peer.create_host()
		
		multiplayer.multiplayer_peer = peer
		print("Lobby created, lobby id: ", lobby_id)
		get_lobby_members()
		hosted.emit()

func _on_lobby_joined(this_lobby_id: int, _permissions: int, _locked: bool, response: int):
	if !is_joining: return
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		lobby_id = this_lobby_id
		peer = SteamMultiplayerPeer.new()
		peer.server_relay = true
		peer.create_client(Steam.getLobbyOwner(lobby_id))
		multiplayer.multiplayer_peer = peer
		is_joining = false
		
		get_lobby_members()
		make_p2p_handshake()
		hosted.emit()

func _on_join_requested(this_lobby_id: int, _this_steam_id: int):
	join_lobby(this_lobby_id)

func send_p2p_packet(this_target: int,packet_data: Dictionary, send_type: int = 0):
	var channel: int = 0
	var this_data: PackedByteArray
	this_data.append_array(var_to_bytes(packet_data))
	
	if this_target == 0: # 0 is all players
		if lobby_members.size() > 1:
			for member in lobby_members:
				if member['steam_id'] != Steamworks.steam_id:
					Steam.sendP2PPacket(member['steam_id'],this_data,send_type,channel)
	else:
		Steam.sendP2PPacket(this_target,this_data,send_type,channel)

func _on_p2p_session_request(remote_id: int):
	var this_requestor: String = Steam.getFriendPersonaName(remote_id)
	
	Steam.acceptP2PSessionWithUser(remote_id)
	make_p2p_handshake()

func make_p2p_handshake():
	send_p2p_packet(0,{"message": "handshake","steam_id": Steamworks.steam_id, "username": Steamworks.steam_username})

func read_p2p_packet():
	var packet_size: int = Steam.getAvailableP2PPacketSize(0)
	
	if packet_size > 0:
		var this_packet: Dictionary = Steam.readP2PPacket(packet_size,0)
		var packet_sender: int = this_packet['remote_steam_id']
		var packet_code: PackedByteArray = this_packet['data']
		var readable_data: Dictionary = bytes_to_var(packet_code)
		
		if readable_data.has("message"):
			match readable_data["message"]:
				"handshake":
					print("PLAYER: ", readable_data["username"], " HAS JOINED!!!")
					get_lobby_members()

func read_all_p2p_packets(read_count: int = 0):
	if read_count >= PACKET_READ_LIMIT:
		return
	if Steam.getAvailableP2PPacketSize(0) > 0:
		read_p2p_packet()
		read_all_p2p_packets(read_count + 1)

func upnp_startup():
	var upnp = UPNP.new()
	var discover_result = upnp.discover()
	if discover_result == UPNP.UPNP_RESULT_SUCCESS:
		if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
			
			var map_result_udp = upnp.add_port_mapping(PORT, PORT, "godot_udp", "UDP", 0)
			var map_result_tcp = upnp.add_port_mapping(PORT, PORT, "godot_udp", "TCP", 0)
			#print("port forwarded")
			if not map_result_udp == UPNP.UPNP_RESULT_SUCCESS:
				upnp.add_port_mapping(PORT, PORT, "", "UDP")
			
			if not map_result_tcp == UPNP.UPNP_RESULT_SUCCESS:
				upnp.add_port_mapping(PORT, PORT, "", "TCP")
			host_ip = upnp.query_external_address()

func _exit_tree() -> void:
	if multiplayer.is_server():
		var clients = multiplayer.get_peers()
		for i in clients.size():
			multiplayer.multiplayer_peer.disconnect_peer(i,false)
