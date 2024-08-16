extends Node2D

@onready var cam = $Camera2D
@onready var label = $"../CanvasLayer/Label"
@onready var island1 = $"../islnd/Islands".position
@onready var islands_2 = $"../islnd/Islands2".position
@onready var islands_3 = $"../islnd/Islands3".position
@onready var islands_4 = $"../islnd/Islands4".position
@onready var islands_5 = $"../islnd/Islands5".position
@onready var islands_6 = $"../islnd/Islands6".position
@onready var islands_7 = $"../islnd/Islands7".position
@onready var islands_8 = $"../islnd/Islands8".position
@onready var islands_9 = $"../islnd/Islands9".position


var speed = 10
var cam_move = true

# Called when the node enters the scene tree for the first time.
func _ready():
	cam.enabled = false
	$"../CanvasLayer/Camspeed".visible = false
	update_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("F3") and cam.enabled == false:
		if cam_move == false:
			cam_move = true
		label.visible = false
		$"../CanvasLayer/Camspeed".visible = true
		Global.player_canmove = false
		Global.player_camera_enable = false
		cam.enabled = true
	elif Input.is_action_just_pressed("F3") and cam.enabled == true:
		$"../CanvasLayer/Camspeed".visible = false
		label.visible = true
		Global.player_canmove = true
		Global.player_camera_enable = true
		cam.enabled = false
	if cam.enabled == true and Input.is_action_just_pressed("Block F3 cam") and cam_move == true:
		cam_move = false
		Global.player_canmove = true
	elif cam.enabled == true and Input.is_action_just_pressed("Block F3 cam") and cam_move == false:
		cam_move = true
		Global.player_canmove = false
	if ["W", "A", "S", "D"].any(Input.is_action_pressed) and cam.enabled == true and cam_move:
		cam.position += Vector2(Input.get_axis("A", "D"), Input.get_axis("W", "S")).normalized() * speed
	
	if Input.is_action_just_pressed("+") and cam.enabled:
		speed += 10
		update_text()
	elif Input.is_action_just_pressed("-") and cam.enabled == false and speed > 10:
		speed -= 10
		update_text()
	if cam.enabled == true:
		if Input.is_action_just_pressed("1"):
			change_pos(island1)
		elif Input.is_action_just_pressed("2"):
			change_pos(islands_2)
		elif Input.is_action_just_pressed("3"):
			change_pos(islands_3)
		elif Input.is_action_just_pressed("4"):
			change_pos(islands_4)
		elif Input.is_action_just_pressed("5"):
			change_pos(islands_5)
		elif Input.is_action_just_pressed("6"):
			change_pos(islands_6)
		elif Input.is_action_just_pressed("7"):
			change_pos(islands_7)
		elif Input.is_action_just_pressed("8"):
			change_pos(islands_8)
		elif Input.is_action_just_pressed("9"):
			change_pos(islands_9)
	


func _input(event):
	if event is InputEventMouseButton and cam.enabled:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			cam.zoom += Vector2(0.01, 0.01)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and cam.zoom > Vector2(0.01, 0.01):
			cam.zoom -= Vector2(0.01, 0.01)
func change_pos (key: Vector2):
	cam.position = Vector2(key)
	if key == Vector2(0, 440):
		$"../Player".position = Vector2(-5067, 775)
	else:
		$"../Player".position = cam.position
		
	
	
func update_text ():
	$"../CanvasLayer/Camspeed".text = "Camera speed: " + str(speed / 10)
