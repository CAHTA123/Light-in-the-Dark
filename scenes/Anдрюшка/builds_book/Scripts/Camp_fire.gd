extends StaticBody2D

@onready var press_e = $Panel
@onready var load_progress = $Panel/TextureProgressBar
@onready var anim = $AnimatedSprite2D
var fire_state = 0
var is_in_area = false
#
func _ready():
	press_e.visible = false
#
#
func _on_interaction_body_entered(_body):
	press_e.visible = true

#
#
func _on_interaction_body_exited(body):
	press_e.visible = false

#
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_E and load_progress.value != 100 and press_e.visible:
			load_progress.value += 10
		else:
			if load_progress.value == 100:
				match fire_state:
					0:
						anim.play("Fire_start")
						await anim.animation_finished
						anim.play("Fire")
						fire_state = 1
					1:
						anim.play("Fire_finish")
						await anim.animation_finished
						anim.play("not_fire")
						fire_state = 0
			load_progress.value = 0 
