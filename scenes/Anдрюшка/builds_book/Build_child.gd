extends Control

@onready var necessary_item = $VBoxContainer/GridContainer
@onready var slot = "res://scenes/GUI/Inventory_test/slot.tscn"
@onready var build_texture = $TextureRect
@onready var build_name = $VBoxContainer/Name

@export var necessary_items: Inventory


