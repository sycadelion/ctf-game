class_name party_list extends VBoxContainer

@export var party_listing_scene: PackedScene
@export var player_colors: Array[Color]
@export var client_player_avatar: Texture
var player_id: int
@onready var client_player_listing: player_listing = $PartyListing

func _ready() -> void:
	if !is_multiplayer_authority(): 
		return
	client_player_listing.player_color = player_colors[clientmanager.client_player_slot]
	client_player_listing.updated_color.emit()
	client_player_listing.player_texture = client_player_avatar
	for i in clientmanager.player_count:
		if i == clientmanager.client_player_slot: continue
		add_party_listing(i)

func add_party_listing(this_slot: int, this_size: int = 32):
	if !is_multiplayer_authority(): 
		return
	var party_listing:player_listing = party_listing_scene.instantiate()
	#party_listing.player_color = player_colors[this_slot]
	#party_listing.player_texture = this_texture
	party_listing.avatar_size = this_size
	self.add_child(party_listing)
	self.move_child(party_listing,2)
	party_listing.score_label.self_modulate = player_colors[this_slot]

func update_color():
	if !is_multiplayer_authority(): 
		return
