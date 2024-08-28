extends Body

@export var inv: Inventory
@export var weapon: Weapon
@export var pickaxe: Pickaxe
@export var axe: Axe
@export var shield: Shield
@onready var camera_2d = $Camera2D.enabled
var adamage
var pdamage
var now_slot = null
var action_objectw
var last_move
var current_state : States
enum States {IDLE, MOVE, DASH, ATTACK, BLOCK , TAKEDAMAGE}

func _process(delta):
	$Camera2D.enabled = camera_2d
	
