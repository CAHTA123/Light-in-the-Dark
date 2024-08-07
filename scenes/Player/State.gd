extends Node2D

@onready var body = $"../../Body"
@onready var audio = $"../../Body/Audio"
func _ready():
	body.current_state = body.States.IDLE

func _process(delta):
	match (body.current_state):
		body.States.IDLE:
			audio.stream = null
			body.velocity = Vector2(0,0)
			body.isBlocking = false
		body.States.MOVE:
			var a = load("res://sounds/player/walk.mp3")
			if audio.stream != a:
				audio.pitch_scale = 0.7
				audio.stream = a
				audio.play()
		body.States.DASH:
<<<<<<< HEAD
			var a = load("res://sounds/player/dash.mp3")
			if audio.stream != a:
				audio.pitch_scale = 2.0
				audio.stream = a
				audio.play()
			body.velocity = body.last_move * 3
=======
			body.velocity *= 1.05
>>>>>>> 4f472aca9c7ace603bae62e940d7e9f78db777ce
		body.States.ATTACK:
			var a = load("res://sounds/Sword/swing  (2).mp3")
			if audio.stream != a:
				audio.pitch_scale = 1
				audio.stream = a
				audio.play()
		body.States.BLOCK:
			body.isBlocking = true
		body.States.TAKEDAMAGE:
			if body.isBlocking == true:
				var a = load("res://sounds/take_damage/dam-1.mp3")
				if audio.stream != a:
					audio.pitch_scale = 1
					audio.stream = a
					audio.play()
			else:
				var a = load("res://sounds/take_damage/dam-2.mp3")
				if audio.stream != a:
					audio.pitch_scale = 1
					audio.stream = a
					audio.play()
