class_name State extends Node

signal Transition

func Enter():
	if !is_multiplayer_authority(): 
		return

func Update(_delta:float):
	if !is_multiplayer_authority(): 
		return

func Physics_Update(_delta:float):
	if !is_multiplayer_authority(): 
		return

func Exit():
	if !is_multiplayer_authority(): 
		return
