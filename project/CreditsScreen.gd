extends Control

@onready var MainNode = $/root/main
@onready var GameNode = $/root/main/Game

@onready var DeathCountLabel = $DeathCountLabel
@onready var TimeElapsedLabel = $TimeElapsedLabel
@onready var MotivationalLabel = $MotivationalLabel
@onready var CheckpointsDisabledLabel = $CheckpointsDisabledLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	var death_counter_active = MainNode.settings["death_counter_active"]
	var track_time = MainNode.settings["track_time"]
	var disable_checkpoints = MainNode.settings["disable_checkpoints"]
	
	if death_counter_active:
		DeathCountLabel.visible = true
		DeathCountLabel.text = str(GameNode.death_count) + "\nDeaths"
		
		if not track_time:
			DeathCountLabel.position.x += 100
	
	if track_time:
		TimeElapsedLabel.visible = true
		var elapsed_time = Time.get_unix_time_from_system() - GameNode.game_start_time
		TimeElapsedLabel.text = GameNode.format_time_elapsed(elapsed_time) + "\nTime"
		
		if not death_counter_active:
			TimeElapsedLabel.position.x -= 100
	
	if disable_checkpoints:
		CheckpointsDisabledLabel.visible = true
		if not death_counter_active and not track_time:
			CheckpointsDisabledLabel.position.y -= 80
	
	
	# If neither stat is shown then show a motivational message
	if not death_counter_active and not track_time and not disable_checkpoints:
		MotivationalLabel.visible = true


func _on_main_menu_button_pressed():
	MainNode.to_main_menu()
