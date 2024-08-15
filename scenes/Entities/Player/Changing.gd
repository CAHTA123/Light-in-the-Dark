extends Node2D

@onready var _1 = $"../../Pause/Control/1"
@onready var _2 = $"../../Pause/Control/2"
@onready var _3 = $"../../Pause/Control/3"
@onready var skin = $"../../Skin/Skin/Weapon/shape/Skin"
@onready var b = $"../.."

var now_slot

func _ready():
	check()


func check():
	
	skin.texture = now_slot.texture
