extends Node2D

@export var input = true
@export var ID = 0

@onready var TeleportParent = $".."
@onready var PlayerNode = $/root/main/Game/player

func _ready():
	if not input:
		$OrangeSprite.hide()
		$BlueSprite.show()
		$Area2D.monitoring = false

func _on_area_2d_body_entered(body):
	for TeleportNode in TeleportParent.get_children():
		# find a teleporter that isnt self and has
		# a matching ID as self
		if TeleportNode != self and TeleportNode.ID == ID:
			PlayerNode.position = TeleportNode.position
