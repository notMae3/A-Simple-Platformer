extends Control

@onready var MainNode = $/root/main
@onready var GameNode = $/root/main/Game

@onready var TimeElapsedLabel = $TimeElapsed/ColorRect/Label
@onready var DeathCounterLabel = $DeathCounter/ColorRect/Label
@onready var DeathCounterBg = $DeathCounter/ColorRect
#@onready var OrgDeathCounterLabelSize = DeathCounterLabel.size

@onready var EscLabel = $EscLabel/Label
@onready var EscLabelFadeOutTimer = $EscLabel/FadeOutTimer
@onready var FadeOutStartDelayTimer = $EscLabel/FadeOutStartDelayTimer
var active_timer = "startup"


func _ready():
	# hide the stats if the player chooses to not track them 
	$TimeElapsed.visible = MainNode.settings["track_time"]
	$DeathCounter.visible = MainNode.settings["death_counter_active"]

func _process(delta):
	# Time tracker
	var elapsed_time = Time.get_unix_time_from_system() - GameNode.game_start_time
	TimeElapsedLabel.text = GameNode.format_time_elapsed(elapsed_time)
	
	# Death counter
	DeathCounterLabel.text = " Deaths: " + str(GameNode.death_count)
	DeathCounterBg.size.x = 139 + str(GameNode.death_count).length() * (16 + 2)
	
	# Esc label
	if active_timer == "fade out" and EscLabelFadeOutTimer.time_left != 0:
		EscLabel.set_modulate(Color(1,1,1,1*EscLabelFadeOutTimer.time_left))


func _on_fade_out_start_delay_timer_timeout():
	EscLabelFadeOutTimer.start()
	active_timer = "fade out"
