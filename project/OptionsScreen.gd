extends Control

@onready var MainNode = $/root/main

func _on_main_menu_button_pressed():
	MainNode.to_main_menu()
