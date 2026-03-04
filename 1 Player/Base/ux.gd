class_name player_ui extends CanvasLayer

@export var skill_ux_array: Array = []

@onready var crosshair_texture: TextureRect = $Crosshair/Crosshair_texture
@onready var skill_basic: Skill_ux = $Skills/SkillBasic
@onready var skill_primary: Skill_ux = $Skills/SkillPrimary
@onready var skill_secondary: Skill_ux = $Skills/SkillSecondary
@onready var skill_ultimate: Skill_ux = $Skills/SkillUltimate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !is_multiplayer_authority(): # just in case block non-authority
		return
	skill_ux_array= [skill_basic,skill_primary,skill_secondary,skill_ultimate]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _toggle_visible(this_visible: bool):
		self.visible = this_visible

func _update_skill_enabled(this_slot: int, this_enable: bool):
	skill_ux_array[this_slot].enabled = this_enable

func _update_skill_charges(this_slot: int, this_charges: int):
	skill_ux_array[this_slot].charges = this_charges

func _update_skill_charges_max(this_slot: int, this_charges: int):
	skill_ux_array[this_slot].charges_max = this_charges

func _update_skill_cooldown(this_slot: int, this_cooldown: float):
	skill_ux_array[this_slot].cooldown = this_cooldown

func _update_skill_icon(this_slot: int, this_texture: Texture):
	skill_ux_array[this_slot].icon_img = this_texture

func _update_skill_input(this_slot: int, this_texture: Texture):
	skill_ux_array[this_slot].input_texture = this_texture
