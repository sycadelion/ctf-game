class_name PlayerAirState extends PlayerMovementState

func Enter():
	PLAYER.anim_player_audio.stop()
	PLAYER.current_player_state = PLAYER.Player_state_modes.AIR
	#PLAYER.anim_tree["parameters/FallAndFloor/transition_request"] = "Idle"

func Update(_delta: float):
	if PLAYER.is_on_floor():
		#PLAYER.audio_comp.audio_landed.emit()
		if Input.is_action_pressed("Crouch"):
			Transition.emit(self,"PlayerCrouchIdleState")

		if PLAYER.velocity.length() > 0.0:
			if Input.is_action_pressed("Sprint"):
				Transition.emit(self, "PlayerSprintState")
			else:
				Transition.emit(self,"PlayerWalkState")
		else:
			Transition.emit(self, "PlayerIdleState")
