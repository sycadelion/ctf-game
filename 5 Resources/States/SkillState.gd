class_name SkillState extends State

@export_group("Parameters")
@export var damage: int = 0
@export var cooldown: float = 1.0
@export var charges: int = 1
@export var charges_max: int = 1
@export_group("UX Parameters")
@export var skill_ux: Skill_ux
@export var skill_texture: Texture
@export var skill_input: Texture
@export_group("Timers")
@export var cooldown_timer: Timer
@export_group("States")
@export var skill_idle: String
@export var skill_basic: String
@export var skill_primary: String
@export var skill_secondary: String
@export var skill_ultimate: String

func _enter_tree() -> void:
	set_multiplayer_authority(get_parent().get_parent().name.to_int())
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !is_multiplayer_authority(): 
		return
	# in case forgot to set max charges when setting a higher amount
	charges_max = charges
	if cooldown_timer:
		cooldown_timer.wait_time = cooldown
		cooldown_timer.timeout.connect(timeout)
	if skill_ux:
		skill_ux.charges = charges
		skill_ux.icon_img = skill_texture
		skill_ux.input_texture = skill_input

func _process(_delta: float) -> void:
	if skill_ux:
		skill_ux.charges = charges

func _input(_event: InputEvent) -> void:
	if !is_multiplayer_authority(): 
		return

func timeout():
	pass
