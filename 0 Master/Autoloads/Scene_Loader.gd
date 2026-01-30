class_name SceneLoader extends Node

##Scenes and Transitions
@export_group("Scenes and Transitions")
@export var Wwise_comp: PackedScene ## The scene that hold Wwise Banks
@export var Default_Scene: PackedScene ##The Scene that is loaded on runtime
@export var Current_Scene: Node ##The Scene that is currently active and shown
@export var Fade_Scene: PackedScene ##The Scene that fades the screen
@export var Load_Scene: PackedScene ##The loading screen scene

##Component Scenes
@export_group("Default Component Scenes")

##Container Nodes
@onready var Components: Node =  $"Component Container"
@onready var Scenes: Node = $Scene
@onready var player_container: Node = $"Player Container"
@onready var effect_container: Node = $"Effect Container"
@onready var ui_container: Node = $"UI Container"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Load_Component(Wwise_comp)
	Change_Scene(Default_Scene)

##Load a component and add it to the component container
func Load_Component(_component) -> void:
	Components.add_child(_component.instantiate())

##Deletes a component from Scene Tree
func Remove_Component(_component: PackedScene) -> void:
	var Scene_to_remove = _component.instantiate()
	
	for c in Components.get_children():
		if c.name == Scene_to_remove.name:
			Components.remove_child(c)
			c.queue_free()
			Scene_to_remove = null
			return

##changes scene, deletes previous scene, updates current scene
func Change_Scene(this_scene: PackedScene) -> void:
	var Next_Scene = this_scene.instantiate()
	
	if Next_Scene == Current_Scene:
		return
	for c in Scenes.get_children():
		Scenes.remove_child(c)
		c.queue_free()
	Scenes.add_child(Next_Scene)
	Current_Scene = Next_Scene
	Next_Scene = null
