extends Resource
class_name Ability

@export var name: String
@export var cooldown: float = 1.0

var _cooldown_elapsed := 0.0
var _on_cooldown := false

func update(delta: float) -> void:
	if _on_cooldown:
		_cooldown_elapsed += delta
		if _cooldown_elapsed >= cooldown:
			_on_cooldown = false
			_cooldown_elapsed = 0.0
			print("%s cooldown finished" % name)

func can_activate() -> bool:
	return not _on_cooldown

func activate(user: Node2D) -> void:
	if not can_activate(): return
	print("%s activated by %s" % [name, user.name])
	perform_action(user)
	_on_cooldown = true
	_cooldown_elapsed = 0.0

func perform_action(user: Node2D) -> void:
	# Override this in child classes
	pass
