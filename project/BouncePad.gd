extends Sprite2D

@onready var PlayerNode = $/root/main/Game/player


func _on_area_2d_body_entered(body):
	PlayerNode.is_on_bounce_pad = true

func _on_area_2d_body_exited(body):
	PlayerNode.is_on_bounce_pad = false
