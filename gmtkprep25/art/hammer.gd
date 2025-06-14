extends Player

@onready var art_scale = $hammer_art.scale.x
@onready var anim_p = $AnimationPlayer

@export var dash_power = 650
var dash_direction

var dashing = false
var anim_jumping = false

func walk_right() -> void:
	super()
	$hammer_art.scale.x = art_scale
	animate("run")

func walk_left() -> void:
	super()
	$hammer_art.scale.x = -art_scale
	animate("run")


func jump() -> void:
	super()
	animate("jump")
	anim_jumping = true

func handle_visuals():
	if walk_direction == 0:
		animate("idle")


func animate(animation):
	match animation:
		"idle":
			if !dashing:
				if !anim_jumping:
					anim_p.play("idle")
		"run":
			if !dashing:
				if !anim_jumping:
					anim_p.play("run")
		"jump":
			if !dashing:
				anim_p.play("jump")
		"dash":
			anim_p.play("dash")
			anim_jumping = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "jump":
		anim_jumping = false
