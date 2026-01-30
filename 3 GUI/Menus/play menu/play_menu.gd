extends Control

signal host_pressed

@onready var back_button: Button = %backButton
@onready var host_button: Button = $"PanelContainer/MarginContainer/Main options/buttons/hostButton"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_host_button_pressed() -> void:
	host_pressed.emit()


func _on_join_steam_button_pressed() -> void:
	Steam.activateGameOverlay("friends")


func _on_join_ip_button_pressed() -> void:
	%"Main options".hide()
	%"Ip enter".show()


func _on_line_edit_text_changed(new_text: String) -> void:
	pass
	#if new_text.length() > 0:
		#%joinButton.disabled = false


func _on_back_button_2_pressed() -> void:
	%"Ip enter".hide()
	%"Main options".show()


func _on_join_button_pressed() -> void:
	Networking.join_lobby(0,$"PanelContainer/MarginContainer/Ip enter/LineEdit".text)
