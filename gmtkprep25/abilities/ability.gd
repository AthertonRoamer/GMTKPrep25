class_name Ability
extends Node2D

@export var ability_name: String
@export var cooldown: float = 1.0

var cooldown_elapsed := 0.0
var on_cooldown := false


func _process(delta: float) -> void:
	if on_cooldown:
		cooldown_elapsed += delta
		if cooldown_elapsed >= cooldown:
			on_cooldown = false
			cooldown_elapsed = 0.0


func can_activate() -> bool:
	return not on_cooldown


func activate(user: Node2D) -> void:
	if not can_activate(): return
	perform_action(user)
	on_cooldown = true
	cooldown_elapsed = 0.0


func perform_action(user: Node2D) -> void:
	# Override this in child classes
	pass
