extends Node2D

var spawn_points: Array = []
@onready var players: Node2D = $Players

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Networking.is_host:
		spawn_points = %Spawn_points.get_children()
		%Button.show()
	Global.lobby.set_player_loaded.rpc(multiplayer.get_unique_id())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if multiplayer.is_server():
		%MultiplayerSpawner.queue_free()
		players.queue_free()
	Global.lobby.back_to_lobby.emit()

func spawn_players(id: int = 1):
	if not multiplayer.is_server():
		return
	var player: Node2D = Global.lobby.player_scene.instantiate()
	var spawn_loc = spawn_points.pick_random()
	player.name = str(id)
	players.call_deferred("add_child",player)
	player.position =  spawn_loc.position
	spawn_points.erase(spawn_loc)
	toggle_camera.rpc()

@rpc("authority","call_local")
func toggle_camera():
	%Camera2D.enabled = false
