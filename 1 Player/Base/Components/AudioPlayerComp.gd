class_name AudioPlayerComp extends Node

signal audio_landed
signal audio_jumped
signal audio_walked
signal audio_sprinted
signal audio_attacked
signal audio_damaged

@export_group("Feet Audio")
@export var feet_audio: AkEvent3D
@export_subgroup("Switches")
@export var feet_switch: String
@export var feet_switch_jump: String
@export var feet_switch_extra: String
@export_subgroup("Raycast")
@export var feet_material_raycast: RayCast3D
@export var feet_material_var: String
@export_group("Entity Audio")
@export var entity_audio: AkEvent3D
@export_subgroup("Movement")
@export var entity_movement_switch: String
@export var entity_movement_switch_jump: String
@export var entity_movement_switch_extra: String
@export_subgroup("Effects")
@export var entity_effects_switch: String
@export var entity_effects_switch_jump: String
@export var entity_effects_switch_extra: String

func _ready() -> void:
	audio_landed.connect(play_land)
	audio_jumped.connect(play_jump)
	audio_walked.connect(play_walk)
	audio_sprinted.connect(play_sprint)
	audio_attacked.connect(play_attack)
	audio_damaged.connect(play_damage)
	if feet_audio:
		#Sets the default switch for the material sound of the footsteps
		Wwise.set_switch(feet_switch,feet_material_var,feet_audio)

func _process(_delta: float) -> void:
	if Engine.get_frames_drawn() %5 == 0:
		_update_Feet_mat()

func _update_Feet_mat() -> void:
	if feet_material_raycast:
		if feet_material_raycast.get_collider():
			if feet_material_raycast.get_collider().has_method("get_material_type"):
				feet_material_var = feet_material_raycast.get_collider().get_material_type()

func play_jump() -> void:
	if feet_audio:
		#Switches the footstep sounds to jump
		Wwise.set_switch(feet_switch_jump,"Jump",feet_audio)
		Wwise.set_switch(feet_switch_extra,"Jump",feet_audio)
		feet_audio.post_event()
	if entity_audio:
		#Switches the entity sounds to jump
		Wwise.set_switch(entity_movement_switch_jump,"Jump",entity_audio)
		Wwise.set_switch(entity_movement_switch,"Jump",entity_audio)
		entity_audio.post_event()

func play_land() -> void:
	if feet_audio:
		#Switches the footstep sounds to landing
		Wwise.set_switch(feet_switch_jump,"Land",feet_audio)
		Wwise.set_switch(feet_switch_extra,"Jump",feet_audio)
		_update_Feet_mat()
		feet_audio.post_event()
	if entity_audio:
		#Switches the entity sounds to landing
		Wwise.set_switch(entity_movement_switch,"Jump",entity_audio)
		Wwise.set_switch(entity_movement_switch_jump,"Land",entity_audio)
		entity_audio.post_event()

func play_walk() -> void:
	if feet_audio:
		#Switches the material sound of the footsteps
		Wwise.set_switch(feet_switch,feet_material_var,feet_audio)
		#Switches the movement speed
		Wwise.set_switch(feet_switch_extra,"Walk",feet_audio)
		feet_audio.post_event()

func play_sprint() -> void:
	if feet_audio:
		#Switches the material sound of the footsteps
		Wwise.set_switch(feet_switch,feet_material_var,feet_audio)
		#Switches the movement speed
		Wwise.set_switch(feet_switch_extra,"Run",feet_audio)
		feet_audio.post_event()

func play_attack() -> void:
	if entity_audio:
		Wwise.set_switch(entity_effects_switch,"Attack",entity_audio)
		entity_audio.post_event()

func play_damage() -> void:
	if entity_audio:
		Wwise.set_switch(entity_effects_switch,"Hurt",entity_audio)
		entity_audio.post_event()
