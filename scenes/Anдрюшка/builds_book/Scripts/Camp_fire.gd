extends StaticBody2D

@onready var press_e = $Press_E
@onready var anim = $AnimatedSprite2D
@onready var time = $Timer.wait_time

var load_progress 
var fire_state = 0
var is_in_area = false
var fire_limit = 2
var flag = true
#
func _ready():
	load_progress = press_e.get_node("TextureProgressBar")
	press_e.visible = false
#
#
func _on_interaction_body_entered(_body):
	if fire_limit != 0:
		press_e.visible = true

#
#
func _on_interaction_body_exited(body):
	press_e.visible = false

#
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_E and load_progress.value != 100 and press_e.visible and fire_limit != 0:
			load_progress.value += 10
		else:
			if load_progress.value == 100:
				if fire_state == 0:
					anim.play("Fire_start")
					await anim.animation_finished
					anim.play("Fire")
					$Timer2.start()
					$Timer.start()
					fire_state = 1
					flag = true
				else:
					fire_state = 3
					if fire_state != 0 and flag:
						if fire_limit == 1:
							press_e.visible = false
							anim.play("Fire_finish")
							$AnimationPlayer.play("queue_free_anim")
							fire_limit -= 1
							print(fire_limit)
							fire_state = 0
							flag = false
						elif flag:
							flag = false
							anim.play("Fire_finish")
							await anim.animation_finished
							anim.play("not_fire")
							if fire_limit != 0:
								fire_limit -= 1
							print(fire_limit)
							fire_state = 0
			load_progress.value = 0 


func _on_timer_timeout():
	if fire_state != 0:
		if fire_limit == 1 and fire_state != 3:
			press_e.visible = false
			anim.play("Fire_finish")
			$AnimationPlayer.play("queue_free_anim")
			fire_limit -= 1
		else:
			anim.play("Fire_finish")
			await anim.animation_finished
			anim.play("not_fire")
			fire_limit -= 1
			fire_state = 0
		


func _on_timer_2_timeout():
	if fire_state == 1:
		$Sprite2D.modulate.v -= 0.01
