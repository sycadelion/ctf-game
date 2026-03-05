class_name player_listing extends HBoxContainer

signal updated_color
signal updated_avatar
signal updated_score(this_score:int )

@export var player_color: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var player_texture: Texture
@export var avatar_size: int = 64

var player_slot: int
var score: int = 0

@onready var player_avatar: TextureRect = $avatar_cont/Player_avatar
@onready var score_label: Label = $Score_Label
@onready var avatar_cont: Control = $avatar_cont

func _ready() -> void:
	if !is_multiplayer_authority(): 
		return
	updated_color.connect(_update_color)
	updated_score.connect(_updated_score)
	avatar_cont.custom_minimum_size = Vector2(avatar_size,avatar_size)
	player_avatar.set_size(Vector2(avatar_size,avatar_size))
	player_avatar.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
	score_label.self_modulate = player_color

func _updated_score(this_score: int):
	score = this_score
	score_label.text = str(score)

func _update_color():
	score_label.self_modulate = player_color

func _updated_avatar():
	pass
