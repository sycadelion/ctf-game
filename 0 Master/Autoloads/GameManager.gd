extends Node

var party_list_node :party_list = null
var client_player_slot: int = 0
var players: Array
var player_count: int = 0

@rpc("authority","call_local")
func update_slot(this_slot_index: int):
	client_player_slot = this_slot_index

@rpc("authority","call_local")
func update_player_count(this_many: int):
	player_count = this_many
