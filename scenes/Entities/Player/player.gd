extends Body

var last_move
var current_state : States
enum States {IDLE, MOVE, DASH, ATTACK, BLOCK , TAKEDAMAGE}

@export var inv: Inventory

@export var weapon: Weapon
@export var pickaxe: Pickaxe
@export var axe: Axe
@export var shield: Shield

var we
var ax
var pi

var adamage
var pdamage

var now_slot = null
