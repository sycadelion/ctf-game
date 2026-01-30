extends Button

signal joining_lobby

var lobby_id: int = 0

func _ready() -> void:
	connect_signals()

func connect_signals() -> void:
	mouse_entered.connect(_on_info_move.bind(true))
	mouse_exited.connect(_on_info_move.bind(false))
	pressed.connect(_on_join_pressed)

func remove_lobby() -> void:
	visible = false
	disabled = true
	queue_free()

func setup_listing(this_id: int, this_mode: String, this_name:String, players_current: int, players_max: int)  -> void:
	lobby_id = this_id
	%Mode.text = this_mode
	%Name.text = this_name
	%Players.text = "%s/%s" % [players_current, players_max]

func _on_join_pressed() -> void:
	if Networking.lobby_id > 0:
		Networking.reset_lobby_data()
	joining_lobby.emit(lobby_id)
	disabled = true

func _on_info_move(is_lowered: bool) -> void:
	%Information.position.y = 5.0 if is_lowered else 0.0
