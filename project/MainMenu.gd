extends Control

@onready var MainNode = $/root/main

func _on_title_button_pressed():
	OS.shell_open("https://notmae3.itch.io/a-simple-platformer")

func _on_start_button_pressed():
	MainNode.start_game()

func _on_options_button_pressed():
	MainNode.to_options_screen()

func _on_quit_button_pressed():
	MainNode.quit()

func _input(event):
	if event.is_action_pressed("1"):
		MainNode.start_game()
	elif event.is_action_pressed("2"):
		MainNode.to_options_screen()

func _on_credits_button_pressed():
	OS.shell_open("https://notmae3.itch.io")
