extends Control
var save_path = "res://savegame.save"
@onready var player = $"../.."
func _ready():
	$".".visible = false


func _process(delta):
	
	if Input.is_action_just_pressed("Esc"):
		$".".visible = true
	
func _on_resume_pressed():
		
		get_tree().paused = false

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(Global.gold)
	file.store_var(player.position.x)
	file.store_var(player.position.y)
func load_game():
	var file = FileAccess.open(save_path, FileAccess.READ)
	Global.gold = file.get_var(Global.gold)
	player.position.x = file.get_var(player.position.x)
	player.position.y = file.get_var(player.position.y)

func _on_save_pressed():
	save_game()



func _on_load_pressed():
	load_game()

