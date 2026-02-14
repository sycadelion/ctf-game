extends Node3D

var spawn_points: Array = []
@onready var timer_label: Label = %timer_label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Networking.is_host:
		%Button.show()
	spawn_points = %Spawn_points.get_children()
	Global.lobby.set_player_loaded.rpc(multiplayer.get_unique_id())
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	Global.lobby.back_to_lobby.emit()

func spawn_players(id: int = 1):
	if not multiplayer.is_server():
		return
	randomize()
	var player: CharacterBody3D = Global.lobby.player_scene.instantiate()
	player.name = str(id)
	Global.lobby.player_container.call_deferred("add_child",player)
	toggle_camera.rpc()

@rpc("authority","call_local")
func toggle_camera():
	%Camera2D.current = false

@rpc("authority","call_local")
func update_timer(this_time: int):
	timer_label.text = "Game starting in: %s" % this_time

@rpc("authority","call_local")
func hide_timer():
	timer_label.hide()


func _on_multiplayer_spawner_despawned(this_node: Node) -> void:
	print("testing ", get_tree().get_multiplayer().get_unique_id())
	this_node.queue_free()
