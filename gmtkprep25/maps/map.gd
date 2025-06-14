class_name Map
extends Node2D

@export var spawn_point_nodes : Array[Node2D] = []

func get_spawn_points() -> Array[Vector2]:
	var points : Array[Vector2] = []
	for s in spawn_point_nodes:
		points.append(s.global_position)
	return points
