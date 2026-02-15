class_name PlayerIdleState extends PlayerMovementState

func Enter():
	PLAYER.anim_player_audio.stop()
	PLAYER.current_player_state = PLAYER.Player_state_modes.IDLE
	#PLAYER.anim_tree["parameters/FallAndFloor/transition_request"] = "Idle"

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
		
		if Input.is_action_pressed("Crouch"):
			Transition.emit(self,"PlayerCrouchIdleState")
