class_name StateMachine extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _enter_tree() -> void:
	set_multiplayer_authority(get_parent().name.to_int())
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !is_multiplayer_authority():
		return
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transition.connect(on_transition)

	if initial_state:
		await owner.ready
		initial_state.Enter()
		current_state = initial_state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	if current_state:
		current_state.Physics_Update(delta)

func on_transition(state: State, new_state_name: String):
	if !is_multiplayer_authority():
		return
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	current_state = new_state
