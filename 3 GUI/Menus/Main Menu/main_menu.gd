extends CanvasLayer

@export var player_scene: PackedScene
@export var player_card: PackedScene

@export var lobby_scene: PackedScene
var lobby_id: int = 0
var peer: SteamMultiplayerPeer
var is_host: bool = false
var is_joining: bool = false
@onready var host_menu: Control = $VBoxContainer/Menus/Host_menu
@onready var play_menu: Control = $VBoxContainer/Menus/Play_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_menu.host_button.pressed.connect(_host_button_pressed)
	host_menu.back_button.pressed.connect(_menu_back)
	Steam.initRelayNetworkAccess()
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_remove_player)
	multiplayer.server_disconnected.connect(server_disconnected)
	Networking.hosted.connect(_on_lobby_hosted)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_lobby_hosted():
	SceneLoad.Change_Scene(lobby_scene)

func _add_player(id: int = 1):
	if not multiplayer.is_server():
		return
	var player = player_scene.instantiate()
	player.name = str(id)
	print("spawned: ", str(id))
	call_deferred("add_child",player)

func _remove_player(id: int):
	if !self.has_node(str(id)):
		return
	
	self.get_node(str(id)).queue_free()

func get_friends():
	var offline_friends: Array
	var online_friends: Array
	var ingame_friends: Array
	
	for i in range(0, Steam.getFriendCount()):
		var friend_id = Steam.getFriendByIndex(i, Steam.FRIEND_FLAG_IMMEDIATE)
		if friend_id == 0:
			break
		var online = Steam.getFriendPersonaState(friend_id)
		var friend = {
			"id": friend_id,
			"online": true if online != 1 else false,
			"game": Steam.getFriendGamePlayed(friend_id),
			"name": Steam.getFriendPersonaName(friend_id)
		}
		if friend.game != {}:
			ingame_friends.append(friend)
		elif friend.online:
			online_friends.append(friend)
		else:
			offline_friends.append(friend)
	for i in ingame_friends:
		spawn_friend_card(i)
		Steam.getPlayerAvatar(64,i.id)
	for i in offline_friends:
		spawn_friend_card(i)
		Steam.getPlayerAvatar(64,i.id)
	for i in online_friends:
		spawn_friend_card(i)
		Steam.getPlayerAvatar(64,i.id)
	

func server_disconnected():
	get_tree().quit()


func spawn_friend_card(friend):
	var current_card = player_card.instantiate()
	current_card.setup_listing(friend.name,friend.id,friend.game,friend.online)
	self.add_child(current_card)

func _host_button_pressed():
	play_menu.hide()
	host_menu.show()

func _menu_back():
	host_menu.hide()
	play_menu.show()
