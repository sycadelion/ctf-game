extends VBoxContainer

@export var party_listing_scene: PackedScene
@export var client_player_color: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var client_player_avatar: Texture

@onready var client_player_listing: player_listing = $PartyListing

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	client_player_listing.player_color = client_player_color
	client_player_listing.player_texture = client_player_avatar

func add_party_listing(this_color: Color, this_size: int):
	var party_listing:player_listing = party_listing_scene.instantiate()
	party_listing.player_color = this_color
	#party_listing.player_texture = this_texture
	party_listing.avatar_size = this_size
	self.add_child(party_listing)
	self.move_child(party_listing,2)
