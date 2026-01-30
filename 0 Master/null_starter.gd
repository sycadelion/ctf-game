extends Node


func _ready() -> void:
	#when game loads delete scene. 
	#This Scene's only purpose is to get the engine to boot and load the custom scene loader.
	queue_free()
