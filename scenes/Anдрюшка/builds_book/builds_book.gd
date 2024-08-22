extends Control

@onready var player_cam = preload("res://scenes/Anдрюшка/camera_zoom/camera_2d.tscn")

var selection_build_place = false
var root_node
var build_prev
var instanse
var canvas_f_build
var cam_zoom = Vector2(1, 1)
# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("change_zoom", _change_zoom)
	root_node = get_tree().root
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if player_cam and selection_build_place and player_cam.zoom != Vector2(1,1):
		#build_prev.scale = build_prev.get_size() 
	if selection_build_place:
		build_prev.position = get_local_mouse_position() - build_prev.get_size() / 2
		print(build_prev.scale * cam_zoom)
		build_prev.scale = Vector2(1,1) * cam_zoom
		
	if Input.is_action_just_pressed("open_builds_list") and !visible:
		open()
	elif Input.is_action_just_pressed("open_builds_list") and visible:
		close()
		
func open ():
	visible = true
	get_tree().paused = true
	
func close ():
	visible = false
	get_tree().paused = false
#func _zoom_change (zoom):
	#build_prev.scale = build_prev.scale * zoom
func build_preview (texture: CompressedTexture2D):
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.modulate.a = 0.3
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(400, 400)
	var canvas = CanvasLayer.new()
	root_node.add_child(canvas)
	canvas_f_build = canvas
	canvas.add_child(preview_texture)
	build_prev = preview_texture
	selection_build_place = true
func _change_zoom (zoom):
	cam_zoom = zoom
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print(event.position / Vector2(0.618056, 0.618056))
			if selection_build_place  and canvas_f_build:
				var preview_texture = TextureRect.new()
				preview_texture.texture = build_prev.texture
				preview_texture.modulate.a = 1
				preview_texture.expand_mode = 1
				preview_texture.size = Vector2(400, 400)
				root_node.add_child(preview_texture)
				preview_texture.position = event.position * cam_zoom
				canvas_f_build.queue_free()
				canvas_f_build = null
				selection_build_place = false
				
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if selection_build_place  and canvas_f_build:
				canvas_f_build.queue_free()
				canvas_f_build = null
				selection_build_place = false
