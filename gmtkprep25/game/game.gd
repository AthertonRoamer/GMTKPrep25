class_name Game
extends Node2D

@export var start_game_on_ready : bool = true
@export var map_scene : PackedScene = preload("res://maps/test_map.tscn")
var map : Map


func _ready() -> void:
	if start_game_on_ready:
		load_game()


func load_game() -> void:
	map = map_scene.instantiate()
	$MapHolder.add_child(map)
	$PlayerManager.spawn_points = map.get_spawn_points()
	$PlayerManager.spawn_players()
	$Camera2D.following_players = true
	
