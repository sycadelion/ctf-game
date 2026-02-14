extends CanvasLayer

@export var lobby_packedscene: PackedScene
@onready var host_menu: Control = $VBoxContainer/Menus/Host_menu
@onready var play_menu: Control = $VBoxContainer/Menus/Play_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_menu.host_button.pressed.connect(_host_button_pressed)
	host_menu.back_button.pressed.connect(_menu_back)
	Networking.hosted.connect(_on_lobby_hosted)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_lobby_hosted():
	SceneLoad.Change_Scene(lobby_packedscene)

#func _add_player(id: int = 1):
	#if not multiplayer.is_server():
		#return
	#var player = player_scene.instantiate()
	#player.name = str(id)
	#print("spawned: ", str(id))
	#call_deferred("add_child",player)
#
#func _remove_player(id: int):
	#if !self.has_node(str(id)):
		#return
	#
	#self.get_node(str(id)).queue_free()

func _host_button_pressed():
	play_menu.hide()
	host_menu.show()

func _menu_back():
	host_menu.hide()
	play_menu.show()
