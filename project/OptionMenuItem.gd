extends Control

@onready var MainNode = $/root/main
@export var text = "Filler text"
@export var var_name = "filler_var"


func _ready():
	$CheckButton.text = text
	$CheckButton.button_pressed = MainNode.settings[var_name]

func _on_check_button_toggled(toggled_on):
	MainNode.settings[var_name] = toggled_on
