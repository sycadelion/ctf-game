extends Control

var player_id: int
var player_name: String = ""
var is_ready: bool = false

@onready var username: RichTextLabel = %Username

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

func change_color():
	print(str(is_ready))
	if is_ready:
		%Username.add_theme_color_override("default_color",Color.WHITE)
		is_ready = false
	elif not is_ready:
		%Username.add_theme_color_override("default_color",Color.WEB_GREEN)
		is_ready = true
