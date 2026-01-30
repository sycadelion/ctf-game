extends Node

#Game Save Version
var SaveVersion: String = "0.0.0"

#Audio Settings:
var MasterBus: float = 50
var MusicBus: float = 50
var DialogBus: float = 50
var SFXBus: float = 50
var ExtraBus1: float = 50
var ExtraBus2: float = 50
var ExtraBus3: float = 50

#User Settings:
var UserName: String = ""
var MouseSensitivity: float = 50
var FieldOfView: float = 90

#Graphic Settings
var FullscreenBool: bool = false
var resolutions_dic : Dictionary = {
								"640 x 360 - 16:9": Vector2i(640, 360),
								"960 x 540 - 16:9": Vector2i(960, 540),
								"1280 x 720 - 16:9": Vector2i(1280, 720),
								"1600 x 900 - 16:9": Vector2i(1600, 900),
								"1920 x 1080 - 16:9": Vector2i(1920, 1080),
								"2560 x 1440 - 16:9": Vector2i(2560, 1440),
								"576 x 360 - 16:10": Vector2i(576, 360),
								"864 x 540 - 16:10": Vector2i(864, 540),
								"1280 x 800 - 16:10": Vector2i(1280, 800),
								"1440 x 900 - 16:10": Vector2i(1440, 900),
								"1920 x 1200 - 16:10": Vector2i(1920, 1200),
								"2560 x 1600 - 16:10": Vector2i(2560, 1600),
								"640 x 480 - 4:3": Vector2i(640, 480),
								"960 x 720 - 4:3": Vector2i(960, 720),
								"1024 x 768 - 4:3": Vector2i(1024, 768),
								"1440 x 1080 - 4:3": Vector2i(1440, 1080),
								"1920 x 1440 - 4:3": Vector2i(1920, 1440)
								}

@onready var current_res: Vector2i = resolutions_dic["1280 x 720 - 16:9"]:
	set(value):
		current_res = value
		DisplayServer.window_set_size(value)
		DisplayServer.window_set_position(DisplayServer.screen_get_size()*.5-\
		DisplayServer.window_get_size() * .5)
		DisplayServer.window_set_current_screen(screen_focus)

var screen_focus: int = 0:
	set(value):
		screen_focus = value
		DisplayServer.window_set_current_screen(value)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set fullscreen or windowed
	if FullscreenBool:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	#set primary screen
	screen_focus = DisplayServer.get_primary_screen()
