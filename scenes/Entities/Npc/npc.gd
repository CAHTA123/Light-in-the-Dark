extends CharacterBody2D

enum {
	IDLE,
	NEW_DIRECT,
	MOVE
}
@onready var anim = $AnimationPlayer

var direction = Vector2.RIGHT
var start_pos

const speed = 100
var current_state = IDLE
var is_roaming = true
var is_chating = false

var player
var player_in_a_chat_zone = false

func _ready():
	randomize()
	start_pos = position
	
func _process(delta):
	if current_state == 0 or current_state == 1:
		anim.play("Idle")
	elif current_state == 2 and !is_chating:
		anim.play("Idle")
		if direction == Vector2.LEFT:
			$Skin.scale.x = -1
		if direction == Vector2.RIGHT:
			$Skin.scale.x = 1
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIRECT:
				direction = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN, Vector2(-1, 1), Vector2(1, -1), Vector2(-1, -1), Vector2(1, 1)])
			MOVE:
				move(delta)
	if Input.is_action_just_pressed("Chat_with_npc"):
		print("chating")
		is_roaming = false
		is_chating = true
			
func choose (array):
	array.shuffle()
	return array.front()
		
func move(delta):
	if !is_chating:
		position += direction * speed * delta


func _on_detected_area_body_entered(body):
	player_in_a_chat_zone = true


func _on_detected_area_body_exited(body):
	player_in_a_chat_zone = false

func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIRECT, MOVE])
