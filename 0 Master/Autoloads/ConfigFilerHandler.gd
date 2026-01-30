extends Node

const save_path = "user://settings.ini"

var config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !FileAccess.file_exists(save_path):
		config.set_value("User","Save_version",SettingsManager.SaveVersion)
		config.set_value("User","Name",SettingsManager.UserName)
		config.set_value("User","Fov",SettingsManager.FieldOfView)
		config.set_value("Mouse","Sensitivity",SettingsManager.MouseSensitivity)
		config.set_value("Audio","Master_audio",SettingsManager.MasterBus)
		config.set_value("Audio","Music_audio",SettingsManager.MusicBus)
		config.set_value("Audio","Dialog_audio",SettingsManager.DialogBus)
		config.set_value("Audio","Sfx_audio",SettingsManager.SFXBus)
		config.set_value("Graphics","Fullscreen",SettingsManager.FullscreenBool)
		config.set_value("Graphics","Resolution",SettingsManager.Resolution)
		
		config.save(save_path)
	else:
		config.load(save_path)

func save_mouse_settings(key: String, value):
	config.set_value("Mouse",key,value)
	config.save(save_path)
	
func load_mouse_settings():
	config.load(save_path)
	var mouse_settings = {}
	for keys in config.get_section_keys("Mouse"):
		mouse_settings[keys] = config.get_value("Mouse", "sensitivity")
	return mouse_settings

func save_audio_settings(key: String, value):
	config.set_value("Audio",key,value)
	config.save(save_path)
	
func load_audio_settings():
	config.load(save_path)
	var audio_settings = {}
	for key in config.get_section_keys("Audio"):
		audio_settings[key] = config.get_value("Audio", key)
	return audio_settings
	
func save_user_settings(name:String):
	config.set_value("User","name",name)
	config.save(save_path)
	
func load_user_settings():
	config.load(save_path)
	var user_settings = {}
	for key in config.get_section_keys("User"):
		user_settings[key] = config.get_value("User", key)
	return user_settings
