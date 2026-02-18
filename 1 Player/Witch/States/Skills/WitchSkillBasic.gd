class_name WitchSkillBasic extends SkillState

var leave: bool = false

func Enter():
	if charges > 0:
		charges -= 1
		leave = true
		if cooldown_timer.is_stopped() and charges != charges_max:
			skill_ux.progress_bar.max_value = cooldown
			cooldown_timer.start(cooldown)
		else:
			pass
	elif  charges == 0:
		leave = true

func Update(_delta:float):
	if leave:
		Transition.emit(self,skill_idle)

func Physics_Update(_delta:float):
	pass

func Exit():
	leave = false

func timeout():
	if charges < charges_max:
		charges += 1
		if charges < charges_max:
			cooldown_timer.start(cooldown)
		else:
			cooldown_timer.stop()
			skill_ux.progress_bar.value = 0
