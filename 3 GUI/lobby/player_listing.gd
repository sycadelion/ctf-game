extends Control

var player_id
var player_name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func setup_listing(this_name: String, id: int):
	if this_name == "":
		player_name = Networking.username
	else:
		player_name = this_name
	player_id = id
	%Username.text = player_name
	if player_id > 0:
		%Avatar.texture = Steamworks.get_avatar_image(player_id)
