extends Node

var steam_id: int = 0
var steam_username: String = ""
var steam_avatars: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#initialize_steam()
	steam_id = Steam.getSteamID()
	steam_username = Steam.getPersonaName()
	Steam.getPlayerAvatar(64,Steamworks.steam_id)
	Steam.avatar_loaded.connect(_on_loaded_avatar)

func initialize_steam() -> void:
	var initialize_response: Dictionary = Steam.steamInitEx()
	print_debug("Did Steam initialize?: %s " %initialize_response)

func _process(_delta: float) -> void:
	Steam.run_callbacks()

func _on_loaded_avatar(user_id: int, avatar_size: int, avatar_buffer: PackedByteArray) ->void:
	# create the image and texture for loading
	var avatar_image: Image = Image.create_from_data(avatar_size,avatar_size,false,Image.FORMAT_RGBA8,avatar_buffer)
	
	# optionally resize the image if its is too large
	if avatar_size > 128:
		avatar_image.resize(128,128,Image.INTERPOLATE_LANCZOS)
	
	# apply the image to a texture
	var steam_avatar = ImageTexture.create_from_image(avatar_image)

func get_avatar_image(this_player_id: int):
	var avatar_id = Steam.getSmallFriendAvatar(this_player_id)
	var avatar_size = Steam.getImageSize(avatar_id)
	var avatar_buffer = Steam.getImageRGBA(avatar_id)
	var avatar_image: Image = Image.create_from_data(avatar_size.width,avatar_size.height,false,Image.FORMAT_RGBA8,avatar_buffer.buffer)
	return ImageTexture.create_from_image(avatar_image)
