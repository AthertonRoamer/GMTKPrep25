extends Player

@onready var art_scale = $hammer_art.scale.x
@onready var shadow_art_scale = $shadow.scale.x
@onready var anim_p = $AnimationPlayer

@export var dash_power = 650
var dash_direction

var dashing = false
var anim_jumping = false

func walk_right() -> void:
	super()
	$hammer_art.scale.x = art_scale
	$shadow.scale.x = shadow_art_scale
	animate("run")

func walk_left() -> void:
	super()
	$hammer_art.scale.x = -art_scale
	$shadow.scale.x = -shadow_art_scale
	animate("run")


func jump() -> void:
	super()
	animate("jump")
	anim_jumping = true

func handle_visuals():
	if walk_direction == 0:
		animate("idle")

func handle_shadow():
	if $shadow_ray.is_colliding():
		#print("hit")
		$shadow.global_position.y = $shadow_ray.get_collision_point().y
		var height_ratio: float = clamp(1.0 - $shadow.position.y / 120.0, 0.2, 1.0)
		$shadow.modulate.a = height_ratio
		var shadow_scale: float = max(height_ratio, 0.6)
		$shadow.scale = Vector2(shadow_scale, shadow_scale)

func process_dash():
	dashing = true
	animate("block")

func animate(animation):
	if is_on_floor():
		anim_jumping = false
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
		"block":
			anim_p.play("block")
			anim_jumping = false

func block_ended():
	dashing = false
	if !is_on_floor():
		anim_p.play("idle")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "jump":
		anim_jumping = false
	if anim_name == "block":
		if Input.is_action_pressed("dash"):
			pass
		else:
			dashing = false
