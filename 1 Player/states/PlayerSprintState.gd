class_name PlayerSprintState extends PlayerMovementState

func Enter():
	PLAYER.current_player_state = PLAYER.Player_state_modes.SPRINT
	PLAYER.anim_player_audio.play("Sprint")
	#PLAYER.anim_tree["parameters/FallAndFloor/transition_request"] = "Move"

func Update(_delta: float):
	if not PLAYER.is_on_floor():
		Transition.emit(self,"PlayerAirState")
		
	if PLAYER.is_on_floor():
		if PLAYER.velocity.length() > 0.0:
			if Input.is_action_pressed("Sprint"):
				Transition.emit(self, "PlayerSprintState")
			else:
				Transition.emit(self,"PlayerWalkState")
		else:
			Transition.emit(self, "PlayerIdleState")

		if Input.is_action_just_pressed("Jump"):
			Transition.emit(self,"PlayerAirState")
		
		if Input.is_action_just_pressed("Crouch"):
			Transition.emit(self,"PlayerCrouchIdleState")

func Exit():
	pass
