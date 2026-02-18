class_name Skill_ux extends Control

@export var charges: int = 1
@export var charges_max: int = 1
@export var icon_img: Texture
@export var input_texture: Texture

@onready var charges_label: Label = $Charges_label
@onready var skill_icon: TextureRect = %Skill_Icon
@onready var input_prompt: TextureRect = $Input_Prompt
@onready var progress_bar: ProgressBar = %ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	charges_label.text = str(charges)
	skill_icon.texture = icon_img
	input_prompt.texture = input_texture

func _process(_delta: float) -> void:
	if charges_max == 1:
		charges_label.text = ""
	else:
		if charges > 0:
			charges_label.text = str(charges)
			skill_icon.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		elif  charges <= 0:
			charges_label.text = ""
			skill_icon.self_modulate = Color(0.365, 0.365, 0.365, 1.0)
