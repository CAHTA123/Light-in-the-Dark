extends CharacterBody2D

var hp: float
var max_hp: float = 10
var hp_bar
var speed = 300
var damage = 2
var take_damage = 0
var take_push = 0
var destroy = false
var center = null
var item_drop = "res://sprites/items/polarbombpotion.png"
var isBlocking = false
var take_push_time: float = 0.4
