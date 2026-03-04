extends Node

signal toggled_ux_visible(this_visible: bool)
signal updated_ux_skill_enabled(this_slot: int, this_enable: bool)
signal updated_ux_skill_charges(this_slot: int, this_charges: int)
signal updated_ux_skill_charges_max(this_slot: int, this_charges: int)
signal updated_ux_skill_cooldown(this_slot: int, this_cooldown: float)
signal updated_ux_skill_icon(this_slot: int, this_texture: Texture)
signal updated_ux_skill_input(this_slot: int, this_texture: Texture)
