class_name lobby_scene extends Node

signal back_to_lobby

@export var server_compo: PackedScene
@export var lobby_member_listing: PackedScene
@export var levels_array: Array[PackedScene] = []

var players_ready: Array[int] = []
var is_ready: bool = false

@onready var lobby_ui: CanvasLayer = $Lobby_ui
@onready var level_options: OptionButton = $Lobby_ui/Level_select/PanelContainer/MarginContainer/Level_options
@onready var buttons: Control = $Lobby_ui/Buttons
@onready var start_button: Button = $Lobby_ui/Buttons/PanelContainer/MarginContainer/HBoxContainer/start_Button
@onready var level_container: Node = $Level_container

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.lobby = self
	Steam.initRelayNetworkAccess()
	multiplayer.server_disconnected.connect(server_disconnected)
	if Networking.is_host:
		back_to_lobby.connect(_on_lobby_return_signal)
		level_options.disabled = false
		SceneLoad.Load_Component(server_compo)

@rpc("authority","call_local")
func spawn_lobby_member_listing(friend: Dictionary, this_id: int):
	var member_listing_scene = lobby_member_listing.instantiate()
	member_listing_scene.name = str(this_id)
	member_listing_scene.setup_listing(friend.steam_name,friend.steam_id)
	%member_list_container.add_child(member_listing_scene)

@rpc("authority","call_local")
func clear_lobby_member_listing():
	for i in %member_list_container.get_children():
		%member_list_container.remove_child(i)
		i.queue_free()

func server_disconnected():
	if OS.has_feature("editor"):
		get_tree().quit()
	else:
		Networking.reset_lobby_data()
		SceneLoad.Change_Scene(SceneLoad.Default_Scene)


func _on_level_options_item_selected(this_index: int) -> void:
	update_level_select.rpc(this_index)

@rpc("authority","call_local")
func update_level_select(this_index: int):
	level_options.selected = this_index

@rpc("authority","call_local")
func change_level():
	lobby_ui.hide()
	for i in level_container.get_children():
		level_container.remove_child(i)
		i.queue_free()
	var this_level = levels_array[level_options.selected].instantiate()
	level_container.add_child(this_level)


func _on_start_button_pressed() -> void:
	change_level.rpc()

func _on_lobby_return_signal():
	return_to_lobby.rpc()

@rpc("authority","call_local")
func return_to_lobby():
	lobby_ui.show()
	for i in level_container.get_children():
		level_container.remove_child(i)
		i.queue_free()

func notify_ready():
	if not is_ready:
		is_ready = true
		set_player_ready.rpc(multiplayer.get_unique_id())
	elif  is_ready:
		is_ready = false
		set_player_unready.rpc(multiplayer.get_unique_id())

@rpc("any_peer", "call_local")
func set_player_ready(id: int):
	if not id in players_ready:
		players_ready.append(id)
		%member_list_container.get_node(str(id)).change_color()
		
		if multiplayer.is_server():
			check_all_players_ready()

@rpc("any_peer", "call_local")
func set_player_unready(id: int):
	if id in players_ready:
		players_ready.erase(id)
		%member_list_container.get_node(str(id)).change_color()
		if multiplayer.is_server():
			check_all_players_ready()

func check_all_players_ready():
	if players_ready.size() == multiplayer.get_peers().size()+1:
		%start_Button.disabled = false
	else:
		%start_Button.disabled = true
