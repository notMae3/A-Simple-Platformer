extends Node2D

var available_levels = 4
var current_level = 0

var bounce_pad_factor = 1.43

@onready var MainNode = $/root/main
@onready var PlayerNode = $player
@onready var MapNode = $map

@onready var CameraNode = $/root/main/Camera2D
@onready var game_frame_size = CameraNode.get_viewport_rect().size / CameraNode.zoom

var game_start_time = Time.get_unix_time_from_system()
var death_count = 0


func _ready():
	MapNode.load_level(1)

func format_time_elapsed(elapsed_time):
	var minute = floor(elapsed_time/60)
	elapsed_time = fmod(elapsed_time, 60.0)
	var second = floorf(elapsed_time)
	return str(minute).pad_zeros(2) + ":" + str(second).pad_zeros(2)

