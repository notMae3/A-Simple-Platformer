extends Node

var settings = {
	"death_counter_active": true,
	"track_time": false,
	"disable_checkpoints": false
}

var CurrentlyShownNode


func load_scene(path):
	CurrentlyShownNode = load(path).instantiate()
	add_child(CurrentlyShownNode)

func clear_children():
	for child in get_children():
		if not child.is_in_group("permanent"):
			child.queue_free()

func start_game():
	clear_children()
	load_scene("res://Game.tscn")

func to_credits_screen():
	clear_children()
	load_scene("res://CreditsScreen.tscn")

func to_main_menu():
	clear_children()
	load_scene("res://MainMenu.tscn")

func to_options_screen():
	clear_children()
	load_scene("res://OptionsScreen.tscn")

func quit():
	get_tree().quit()


func _input(event):
	if event.is_action_pressed("esc"):
		if get_child(1).name != "MainMenu":
			to_main_menu()
