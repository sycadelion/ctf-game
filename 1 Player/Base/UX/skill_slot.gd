class_name Skill_ux extends Control

signal updated_charges(these_charges: int)
signal updated_enabled(this_enabled: bool)
signal updated_cooldown(this_cooldown: float)

@export var enabled: bool = true
@export var charges: int = 1
@export var charges_max: int = 1
@export var cooldown: float = 1.0
@export var icon_img: Texture
@export var input_texture: Texture

@onready var charges_label: Label = $Charges_label
@onready var skill_icon: TextureRect = %Skill_Icon
@onready var input_prompt: TextureRect = $Input_Prompt
@onready var progress_bar: ProgressBar = %ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !is_multiplayer_authority(): # just in case block non-authority
		return
	charges_label.text = str(charges)
	skill_icon.texture = icon_img
	input_prompt.texture = input_texture
	updated_charges.connect(_update_charges)
	updated_enabled.connect(_update_enabled)
	updated_cooldown.connect(_updated_cooldown)
	updated_enabled.emit(enabled)
	updated_cooldown.emit(cooldown)

func _process(_delta: float) -> void:
	pass

func _update_charges(these_charges: int):
	if !is_multiplayer_authority(): # just in case block non-authority
		return
	charges = these_charges
	
	if charges_max == 1: # No need to show charges if there is only 1 max
		charges_label.text = ""
	else:
		if charges > 0:
			charges_label.text = str(charges)
			skill_icon.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		elif  charges <= 0: # No need to show 0 just grey out the skill icon
			charges_label.text = ""
			skill_icon.self_modulate = Color(0.365, 0.365, 0.365, 1.0)

func _update_enabled(this_enabled: bool):
	if !is_multiplayer_authority(): # just in case block non-authority
		return
	enabled = this_enabled
	
	if enabled: # if enabled return full color
		skill_icon.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	else: # else grey out the skill icon
		skill_icon.self_modulate = Color(0.365, 0.365, 0.365, 1.0)
		charges_label.text = ""

func _updated_cooldown(this_cooldown: float):
	progress_bar.max_value = this_cooldown
