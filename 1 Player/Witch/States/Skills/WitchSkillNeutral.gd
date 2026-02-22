class_name WitchSkillNeutral extends SkillState

func Enter():
	pass

func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority():
		return
	if event.is_action_pressed("SkillBasic"):
		Transition.emit(self,skill_basic)

func Update(_delta:float):
	pass

func Physics_Update(_delta:float):
	pass

func Exit():
	pass
