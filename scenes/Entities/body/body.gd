extends CharacterBody2D

class_name Body

var hp: float 
var max_hp: float = 10
var hp_bar
var speed = 300
var damage = 2
var take_damage = 0
var destroy = false
var item_drop = ""



var take_push = 0
var center = null
var take_push_time: float = 0.4
var isBlocking = false

