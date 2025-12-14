extends Node2D

@export var beam_length = 100
@export var oscilation_delta = 0.0
@export var oscilation_timer_start_delay = 1.0
@export var compensate_rotation = false
@export var inverse_cycle = false

@onready var BaseNode = $base
@onready var BeamNode = $beam
@onready var CollisionShapeNode = $Area2D/CollisionShape2D
@onready var OscilationTimerNode = $OscilationTimer

func _ready():
	if compensate_rotation:
		BaseNode.rotation -= rotation
	
	BeamNode.add_point(Vector2(0,beam_length))
	CollisionShapeNode.scale = Vector2(1, beam_length)
	CollisionShapeNode.position.y = beam_length/2
	
	if inverse_cycle:
		BeamNode.visible = not BeamNode.visible
		CollisionShapeNode.disabled = not CollisionShapeNode.disabled
	
	await get_tree().create_timer(oscilation_timer_start_delay).timeout
	
	if oscilation_delta > 0:
		OscilationTimerNode.wait_time = oscilation_delta
		OscilationTimerNode.start()

#func _process(delta):
	#BeamNode.remove_point(1)
	#BeamNode.add_point(Vector2(0,beam_length))
	#CollisionShapeNode.scale = Vector2(1, beam_length)
	#CollisionShapeNode.position.y = beam_length/2
	#
	#if oscilation_delta > 0:
		#OscilationTimerNode.wait_time = oscilation_delta
		#if OscilationTimerNode.is_stopped():
			#OscilationTimerNode.start()
	#
	#else:
		#OscilationTimerNode.stop()

func _on_oscilation_timer_timeout():
	BeamNode.visible = not BeamNode.visible
	CollisionShapeNode.disabled = not CollisionShapeNode.disabled
	
