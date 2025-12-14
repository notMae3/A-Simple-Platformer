extends Node2D

@export var head_scale = Vector2(0.8,0.8)
@export var segments = {
	"1": {
		"shaft_length" : 100,
		"starting_rotation" : 0.0,
		"rotation_speed" : 1.0,
		"clockwise_rotation" : true
		}
}

@onready var BaseNode = $base
@onready var HeadNode = $head

@onready var ShaftParentNode = $ShaftSegments
@onready var HammerShaftSegment = preload("res://HammerShaftSegment.tscn")


func _ready():
	HeadNode.scale = head_scale
	
	for segment_number in segments:
		var segment = segments[segment_number]
		var new_shaft_segment = HammerShaftSegment.instantiate()
		var new_shaft_segment_point = Vector2(0, segment["shaft_length"]).rotated(segment["starting_rotation"])
		
		new_shaft_segment.name = str(segment_number)
		new_shaft_segment.position = get_position_for_shaft_segment(-1)
		
		var new_segment_line = new_shaft_segment.get_node("Line2D")
		new_segment_line.add_point(new_shaft_segment_point)
		
		var new_segment_hitbox = new_shaft_segment.get_node("ShaftHitbox")
		new_segment_hitbox.scale.y = segment["shaft_length"]
		new_segment_hitbox.rotation = segment["starting_rotation"]
		
		var line_point_0 = new_segment_line.get_point_position(0)
		var line_point_1 = new_segment_line.get_point_position(1)
		new_segment_hitbox.position = (line_point_1 - line_point_0)/2
		
		ShaftParentNode.add_child(new_shaft_segment)
		

func get_position_for_shaft_segment(n):
	if ShaftParentNode.get_child_count():
		var SegmentNode = ShaftParentNode.get_child(n)
		return SegmentNode.position + SegmentNode.get_node("Line2D").get_point_position(1)
	else:
		return ShaftParentNode.position

func _process(delta):
	for child_idx in ShaftParentNode.get_child_count():
		var SegmentNode = ShaftParentNode.get_child(child_idx)
		var segment = segments[SegmentNode.name]
		var rotation_direction = 1 if segment["clockwise_rotation"] else -1
		
		var additional_angle = rotation_direction * PI*2*segment["rotation_speed"] * delta
		
		rotate_segment(SegmentNode, additional_angle)

func rotate_segment(SegmentNode, additional_angle):
	var SegmentLine2DNode = SegmentNode.get_node("Line2D")
	
	var angle = SegmentLine2DNode.get_point_position(1).angle() - PI/2	
	var segment = segments[SegmentNode.name]
	
	# rotate the second point of the Line2D
	# effectively rotating the line
	var new_child_point = Vector2(0, segment["shaft_length"]).rotated(angle + additional_angle)
	SegmentLine2DNode.remove_point(1)
	SegmentLine2DNode.add_point(new_child_point)
	
	# match the rotation of the hitbox with the Line2D
	var SegmentHitboxNode = SegmentNode.get_node("ShaftHitbox")
	SegmentHitboxNode.rotation += additional_angle
	
	# update the position of the hitbox to match the Line2D
	var line_point_0 = SegmentLine2DNode.get_point_position(0)
	var line_point_1 = SegmentLine2DNode.get_point_position(1)
	SegmentHitboxNode.position = (line_point_1 - line_point_0)/2
	
	var child_idx = ShaftParentNode.get_children().find(SegmentNode)
	if child_idx+1 < ShaftParentNode.get_child_count():
		var next_segment = ShaftParentNode.get_child(child_idx+1)
		# move the next segment to have its first point be aligned with the
		# end point of the this line
		next_segment.position = SegmentNode.position + SegmentLine2DNode.get_point_position(1)
		# rotate all children by the same angle to create the whip effect
		rotate_segment(next_segment, additional_angle)
	
	# if the current segment is the last segment
	else:
		var head_position = SegmentNode.position + SegmentLine2DNode.get_point_position(1)
		head_position += SegmentLine2DNode.get_point_position(1).normalized() * (HeadNode.texture.get_size() * HeadNode.scale).y/2
		HeadNode.position = head_position
		HeadNode.rotation = angle + additional_angle
