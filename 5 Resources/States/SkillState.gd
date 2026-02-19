class_name SkillState extends State

@export_group("Parameters")
@export var enabled: bool = true
@export var damage: int = 0
@export var cooldown: float = 1.0
@export var charges: int = 1
@export var charges_max: int = 1
@export var group_name: String
@export_group("UX Parameters")
@export var skill_ux: Skill_ux
@export var skill_texture: Texture
@export var skill_input: Texture
@export_group("Timers")
var cooldown_timer: Timer = Timer.new()
@export_group("States")
@export var skill_idle: String
@export var skill_basic: String
@export var skill_primary: String
@export var skill_secondary: String
@export var skill_ultimate: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !is_multiplayer_authority(): # just in case block non-authority
		return
	# Set skill group
	if group_name:
		add_to_group(group_name)
	self.add_child(cooldown_timer)
	if cooldown_timer:
		cooldown_timer.wait_time = cooldown
		cooldown_timer.timeout.connect(timeout)
	if skill_ux:
		skill_ux.enabled = enabled
		skill_ux.charges = charges
		skill_ux.charges_max = charges_max
		skill_ux.icon_img = skill_texture
		skill_ux.input_texture = skill_input
		skill_ux.cooldown = cooldown

func _process(_delta: float) -> void:
	if cooldown_timer:
		if not cooldown_timer.is_stopped():
			skill_ux.progress_bar.value = cooldown_timer.time_left

func _input(_event: InputEvent) -> void:
	if !is_multiplayer_authority(): 
		return

func timeout():
	if charges < charges_max:
		charges += 1
		if charges < charges_max:
			cooldown_timer.start(cooldown)
		else:
			cooldown_timer.stop()
			skill_ux.progress_bar.value = 0
		skill_ux.updated_charges.emit(charges)

func changed_enabled(this_enable: bool):
	print_debug(name, " enabled")
	enabled = this_enable
	skill_ux.updated_enabled.emit(enabled)
	cooldown_timer.start(cooldown)
