extends Node2D

@onready var PlayerNode = $/root/main/Game/player
@onready var GameNode = $/root/main/Game
@onready var MainNode = $/root/main

var current_level_node = null


func get_first_checkpoint_of_current_lvl():
	# - Any children of the first checkpoint of the current level
	# is ignored when fetching the first checkpoint position.
	# - This is because this function is intended to be used for
	# getting the position of where the player should spawn when
	# loading a new level.
	
	return current_level_node.get_node("checkpoints").get_child(0).position

func get_furthest_passed_checkpoint(player_pos: Vector2):
	# - Checkpoints are structured so that a Marker2D's x position
	# acts as the minimum required x value reached by the player for the
	# checkpoint to be unlocked.
	# - Moving below the mininum x value locks all unlocked checkpoints past it.
	# - If this Marker2D node has exactly 1 child (recommended type: Marker2D)
	# then the position of said child will be used as an offset that gets
	# added onto the parent's position. This new position acts as the spawn
	# position of this checkpoint.
	# - All levels has at least 1 checkpoint. This checkpoint is used
	# when first spawning into the level.
	
	# the below code creates a list of sublists
	# [ [min_x_1: float, spawn_pos_1: vec2], [min_x_2: float, spawn_pos_2: vec2] ]
	var min_progression_for_checkpoints = []
	for marker_node in current_level_node.get_node("checkpoints").get_children():
		# If there's exactly 1 child: use its position as spawn position
		if marker_node.get_child_count() == 1:
			var spawn_pos = marker_node.get_child(0).position
			min_progression_for_checkpoints.append([marker_node.position.x, marker_node.position + spawn_pos])
		# otherwise use the Marker2D's position
		else:
			min_progression_for_checkpoints.append([marker_node.position.x, marker_node.position])
	
	# if the player has chosen to play without checkpoints then
	# return the position of the first checkpoint (the one used when first
	# spawning into the level)
	if MainNode.settings["disable_checkpoints"]:
		return min_progression_for_checkpoints[0][1]
	
	# if the player hasn't passed the minimum x value of the first checkpoint
	# return the position of the first checkpoint (the one used when first
	# spawning into the level)
	if player_pos.x <= min_progression_for_checkpoints[0][0]:
		return min_progression_for_checkpoints[0][1]
	
	# otherwise go through all checkpoints in order and check if the player's x
	# position is past the minimum required x value
	# if so the spawn position of that checkpoint is returned
	else:
		# check checkpoints in descending order (late -> early)
		min_progression_for_checkpoints.reverse()
		for min_x_and_spawn_point in min_progression_for_checkpoints:
			var min_x = min_x_and_spawn_point[0]
			if min_x <= player_pos.x:
				return min_x_and_spawn_point[1]

func load_level(n):
	if PlayerNode != null:
		PlayerNode.position = Vector2(0,-1000)
		await get_tree().create_timer(0.01).timeout
	
	if current_level_node != null:
		remove_child(current_level_node)
		current_level_node.queue_free()
	current_level_node = load("res://levels/lvl_" + str(n) + ".tscn").instantiate()
	add_child(current_level_node)
	
	GameNode.current_level = n
	
	PlayerNode.position = get_first_checkpoint_of_current_lvl()

func _on_player_entered_goal_area():
	if GameNode.current_level == GameNode.available_levels:
		MainNode.to_credits_screen()
	else:
		load_level(GameNode.current_level + 1)



