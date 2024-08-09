extends Panel

var ItemClass = preload("res://scenes/item/item.tscn")
var item = null

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var default_tex = preload("res://scenes/inventory/back_slots.png")
var empty_tex = preload("res://scenes/inventory/slot.png")

func _ready():
	if randi() % 2 == 0:
		item = ItemClass.instantiate()
		add_child(item)
		
	default_style = StyleBoxTexture.new( )
	empty_style = StyleBoxTexture.new( )
	default_style. texture = default_tex
	empty_style.texture = empty_tex
	refresh_style()

func refresh_style():
	if item == null:
		set('theme_override_styles/panel',empty_style)
	else:
		set('theme_override_styles/panel', default_style)
		
func pick_from_slot():
	remove_child(item)
	var i = find_parent("inventory")
	i.add_child(item)
	item = null
	refresh_style()

func put_into_slot(new):
	item = new
	item.position = Vector2(0, 0)
	var i = find_parent("inventory")
	i.remove_child(item)
	add_child(item)
	refresh_style()
