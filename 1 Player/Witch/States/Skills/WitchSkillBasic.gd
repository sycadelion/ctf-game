class_name WitchSkillBasic extends SkillState

var leave: bool = false

func Enter():
	if charges > 0:
		charges -= 1
		leave = true
		if cooldown_timer.is_stopped() and charges != charges_max:
			cooldown_timer.start(cooldown)
		else:
			pass
		skill_ux.updated_charges.emit(charges)
	elif  charges == 0:
		leave = true

func Update(_delta:float):
	if leave:
		Transition.emit(self,skill_idle)

func Physics_Update(_delta:float):
	pass

func Exit():
	leave = false
