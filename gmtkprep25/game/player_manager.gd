class_name PlayerManager
extends Node2D

@export var players_to_spawn : Dictionary #key player scene value number
@export var first_player_keyboard_only : bool = false



var spawn_points : Array[Vector2]
var players : Array[Player]
var devices : Array
		


func spawn_players() -> void:
	devices = Input.get_connected_joypads()
	for type in players_to_spawn:
		for i in range(0, players_to_spawn[type]):
			spawn_player(type)
			
			
func spawn_player(type : PackedScene) -> void:
	var p : Player = type.instantiate()
	var num : int = players.size()
	if num == 0:
		p.keyboard_input = true
	if spawn_points.size() < num + 1:
		p.global_position = Vector2(500 * num, 0)
	else:
		p.global_position = spawn_points[num] 
	if first_player_keyboard_only:
		if num != 0 and devices.size() >= num:
			p.device_id = devices[num - 1]
	else:
		if devices.size() >= num + 1:
			p.device_id = devices[num]
	players.append(p)
	add_child(p)
