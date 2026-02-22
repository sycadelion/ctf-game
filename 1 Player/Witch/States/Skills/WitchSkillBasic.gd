class_name WitchSkillBasic extends SkillState

func Enter():
	if charges > 0 and attack_timer.is_stopped():
		charges -= 1
		attack_timer.start(attack_speed)
		if cooldown_timer.is_stopped() and charges != charges_max:
			cooldown_timer.start(cooldown)
		else:
			pass
		skill_ux.updated_charges.emit(charges)
	elif  charges == 0 or not attack_timer.is_stopped():
		Transition.emit(self,skill_neutral)

func Update(_delta:float):
	pass

func Physics_Update(_delta:float):
	pass

func Exit():
	pass
