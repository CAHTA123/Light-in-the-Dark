extends Control

@onready var body = $"../.."

func _ready():
	body.hp = body.max_hp

func _process(delta):
	$Bar.value = (body.hp / body.max_hp) * 100
