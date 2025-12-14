extends CharacterBody2D

@onready var GameNode = $/root/main/Game
@onready var MapNode = $/root/main/Game/map

@onready var PlayerSize = $Sprite2D.texture.get_size() * scale

var GRAVITY = 1550
var SPEED = 700
var JUMP_VELOCITY = -980

var custom_is_on_floor = false
var disable_movement = false
var is_on_bounce_pad = false


func _physics_process(delta):
	if disable_movement: return
	
	#Apply gravity
	if not custom_is_on_floor:
		velocity.y += GRAVITY * delta
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and custom_is_on_floor:
		if is_on_bounce_pad:
			velocity.y = JUMP_VELOCITY*GameNode.bounce_pad_factor
		else:
			velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
	position = position.clamp(PlayerSize/2, GameNode.game_frame_size - PlayerSize/2)

func respawn():
	velocity = Vector2.ZERO
	position = MapNode.get_furthest_passed_checkpoint(position)

func _on_custom_is_on_floor_body_entered(_body):
	custom_is_on_floor = true

func _on_custom_is_on_floor_body_exited(_body):
	custom_is_on_floor = false


func _on_area_hitbox_area_entered(_area):
	GameNode.death_count += 1
	respawn()
