extends Node

@export var menu_scene : PackedScene
var menu : Control

func _ready() -> void:
	pass
	
	
func open_menu() -> void:
	menu = menu_scene.instantiate()
	add_child(menu)
	
	
