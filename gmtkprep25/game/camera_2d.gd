extends Camera2D

@export var player_manager : PlayerManager

var default_position : Vector2
var following_players : bool = false
var ideal_zoom_factor : float = 1
var zoom_speed : float = 0.5 #per sec
var player_seperation_to_window_factor : float = .5

func _ready() -> void:
	default_position = position
	
	
func _process(delta: float) -> void:
	if following_players:
		match player_manager.players.size():
			1:
				position = player_manager.players[0].position
				zoom = Vector2.ONE * ideal_zoom_factor
			2:
				var p1 : Vector2 = player_manager.players[0].position
				var p2 : Vector2 = player_manager.players[1].position
				position = p1 + (p2 - p1) / 2
				
				var camera_scale_h : float = 1
				var camera_scale_v : float = 1
				if p1.x - p2.x > float(get_window().size.x) / 2.: #camera_scale * 2 * dist = win size
					camera_scale_h = float(get_window().size.x) / 2. / (p1.x - p2.x)
				if p1.y - p2.y > float(get_window().size.y) / 2.: #camera_scale * 2 * dist = win size
					camera_scale_v = float(get_window().size.y) / 2. / (p1.y - p2.y)
				var camera_scale = min(camera_scale_v, camera_scale_h)
				var target_zoom = Vector2.ONE * camera_scale
				zoom = lerp(zoom, target_zoom, zoom_speed * delta)
			var _player_count:
				var camera_scale_h : float = 1
				var camera_scale_v : float = 1
				#get greatest and smallest x as well as greatest and smallest y
				var greatest : Vector2 = player_manager.players[0].position
				var smallest : Vector2 = player_manager.players[0].position
				for player in player_manager.players:
					greatest.x = max(greatest.x, player.position.x)
					greatest.y = max(greatest.y, player.position.y)
					smallest.x = min(smallest.x, player.position.x)
					smallest.y = min(smallest.y, player.position.y)
					
				position.x = (greatest.x - smallest.x) / 2 + smallest.x
				position.y = (greatest.y - smallest.y) / 2 + smallest.y
					
				if greatest.x - smallest.x > float(get_window().size.x) / 2.: #camera_scale * 2 * dist = win size
					camera_scale_h = float(get_window().size.x) / 2. / (greatest.x - smallest.x)
				if greatest.y - smallest.y > float(get_window().size.y) / 2.: #camera_scale * 2 * dist = win size
					camera_scale_v = float(get_window().size.y) / 2. / (greatest.y - smallest.y)
				var camera_scale = min(camera_scale_v, camera_scale_h)
				var target_zoom = Vector2.ONE * camera_scale
				zoom = lerp(zoom, target_zoom, zoom_speed * delta)
				
					
				
				
				
				
