class_name PlayerCrouchMoveState extends PlayerMovementState

func Enter():
	PLAYER.anim_player.stop()
	if PLAYER.current_player_state == PLAYER.Player_state_modes.AIR or PLAYER.current_player_state == PLAYER.Player_state_modes.CROUCHIDLE:
		PLAYER.anim_player.play("crouch_skip")
		if PLAYER.current_player_state != PLAYER.Player_state_modes.CROUCHIDLE:
			PLAYER.anim_player_ui.play("Crouch_fade")
	else:
		PLAYER.anim_player.play("crouch_anim")
		PLAYER.anim_player_ui.play("Crouch_fade")
	PLAYER.current_player_state = PLAYER.Player_state_modes.CROUCHMOVE
	PLAYER.anim_player_audio.play("WalkCrouch")
	#PLAYER.anim_tree["parameters/FallAndFloor/transition_request"] = "Idle"

func Update(_delta: float):
	if not PLAYER.is_on_floor():
		Transition.emit(self,"PlayerAirState")

	if PLAYER.is_on_floor():
		if Input.is_action_just_released("Crouch"):
			#uncrouch()
			if PLAYER.velocity.length() > 0.0:
				if Input.is_action_pressed("Sprint"):
					Transition.emit(self, "PlayerSprintState")
				else:
					Transition.emit(self,"PlayerWalkState")
			else:
				Transition.emit(self,"PlayerIdleState")
		if Input.is_action_pressed("Crouch"):
			if PLAYER.velocity.length() <= 0.0:
				Transition.emit(self,"PlayerCrouchIdleState")
		if Input.is_action_just_pressed("Jump"):
			#uncrouch()
			Transition.emit(self,"PlayerAirState")

func Exit():
	pass

func uncrouch():
	PLAYER.anim_player_ui.play_backwards("Crouch_fade")
	PLAYER.anim_player.play_backwards("crouch_anim")
