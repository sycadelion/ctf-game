extends Control

@onready var back_button: Button = $"PanelContainer/MarginContainer/VBoxContainer/Buttons vbox/backButton"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Networking.current_online_mode == Networking.online_mode.STEAM:
		%SteamButton.text = "Steam Multiplayer: %s" % "Enabled"
	else:
		%SteamButton.text = "Steam Multiplayer: %s" % "Disabled"


func _on_steam_button_pressed() -> void:
	if Networking.current_online_mode == Networking.online_mode.STEAM:
		Networking.current_online_mode = Networking.online_mode.ENET
		%SteamButton.text = "Steam Multiplayer: %s" % "Disabled"
	else:
		Networking.current_online_mode = Networking.online_mode.STEAM
		%SteamButton.text = "Steam Multiplayer: %s" % "Enabled"


func _on_allowed_users_button_pressed() -> void:
	if Networking.lobby_type == Steam.LOBBY_TYPE_FRIENDS_ONLY:
		Networking.lobby_type = Steam.LOBBY_TYPE_PUBLIC
		%AllowedUsersButton.text = "Allowed Users: ALL"
	elif Networking.lobby_type == Steam.LOBBY_TYPE_PUBLIC:
		Networking.lobby_type = Steam.LOBBY_TYPE_FRIENDS_ONLY
		%AllowedUsersButton.text = "Allowed Users: FRIENDS"


func _on_host_button_pressed() -> void:
	if Networking.current_online_mode == Networking.online_mode.ENET:
		Networking.upnp_startup()
	Networking.create_lobby()
	self.hide()
