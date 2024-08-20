extends Area2D
##Неигровой персонаж, способный к передвижению по заранее заданному пути.
##Игрок имеет возможность взаимодействовать с ними.
class_name NPC

##Текст появляющейся подсказки при возможности взаимодействия.
##Например: [i]"Нажните E чтобы поговорить"[/i]
@export_multiline var text_hint:String:
	set(value):
		_label.text = value
		_label.size = Vector2.ZERO
		_label.position = Vector2(-_label.size.x/2, 24)
	get:
		return _label.text


@export_subgroup("Moving")
##Будет ли NPC ходить. Должен иметься путь в переменной [member path].
@export var walk:bool
##NPC будет ходить только когда находится в рамках камеры. Требуется [member walk].
@export var walk_only_visible:bool
##Скорость в пикселях в секунду.
@export var speed:float
##Цикличное следование по пути.
@export var loop:bool:
	set(value):
		_path_follow.loop = value
	get:
		return _path_follow.loop

##Прогресс перемещения по длине пути в пикселях.
@export_range(0, 10000, 0.001) var path_progress:float:
	set(value):
		_path_follow.progress = value
	get:
		return _path_follow.progress

##Процент пройденной длины по пути.
@export_range(0, 1, 0.0001) var path_progress_ratio:float:
	set(value):
		_path_follow.progress_ratio = value
	get:
		return _path_follow.progress_ratio


@export_subgroup("Random Speech")
@export var speech_enabled:bool:
	set(value):
		speech_enabled = value
		if value:
			add_child(_speech_timer)
			_speech_bubbble = preload("res://scenes/Entities/npc/speech_bubble.tscn").instantiate()
			add_child(_speech_bubbble)
			_randomizer.randomize()
			_speech_timer.start.call_deferred(_randomizer.randf_range(speech_min_random, speech_max_random))
		else:
			if _speech_bubbble: _speech_bubbble.queue_free()
			if _speech_timer.time_left != 0:
				_speech_timer.stop()
			if _speech_timer.get_parent():
				remove_child.call_deferred(_speech_timer)
@export var speech_lines:Array[SpeechLine]
##Минимальное время между брошенными фразами.
@export_range(0, 100, 0.01) var speech_min_random:float = 0.0
##Максимальное время между брошенными фразами.
@export_range(0, 100, 0.01) var speech_max_random:float = 5.0


@export_subgroup("Nodes")
##Для того чтобы NPC мог знать находится ли на экране.
##Необходимо, чтобы NPC не выполнял лишние вычисления и действия за пределами экрана.
@export var visible_enabler:VisibleOnScreenEnabler2D:
	set(value):
		if value:
			value.screen_entered.connect(__on_screen_entered)
			value.screen_exited.connect(__on_screen_exited)
		if visible_enabler:
			visible_enabler.screen_entered.disconnect(__on_screen_entered)
			visible_enabler.screen_exited.disconnect(__on_screen_exited)
		visible_enabler = value
##Путь, вдоль которого будет выполняться перемещение NPC.
@export var path:Path2D:
	set(value):
		path = value
		if _path_follow.get_parent():
			_path_follow.get_parent().remove_child(_path_follow)
		if path:
			path.add_child(_path_follow)
		path_progress = 0
		path_progress_ratio = 0

var _path_follow:PathFollow2D = PathFollow2D.new()
var _label:Label = Label.new()
var _randomizer:RandomNumberGenerator = RandomNumberGenerator.new()
var _speech_timer:Timer = Timer.new()
var _speech_bubbble:Label

##Имя используемое в диалогах.
var visible_name:StringName

##NPC вошел в поле зрения экрана.
signal screen_entered
##NPC покинул поле зрения экрана.
signal screen_exited


func _init() -> void:
	add_child(_label)
	set_collision_mask_value(2, true)
	
	# Некоторые переменные присваивают сами себя для отработки их сеттеров.
	text_hint = text_hint
	path_progress = path_progress
	path_progress_ratio = path_progress_ratio
	speech_enabled = speech_enabled
	
	_speech_timer.autostart = false
	_speech_timer.one_shot = true
	_speech_timer.timeout.connect(func():
		say()
		_randomizer.randomize()
		await _speech_bubbble.visibility_changed
		_speech_timer.start.call_deferred(_randomizer.randf_range(speech_min_random, speech_max_random))
		)
	
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.label_settings = LabelSettings.new()
	_label.label_settings.font_size = 50
	_label.label_settings.shadow_size = 10
	_label.label_settings.shadow_color = Color.BLACK
	_label.visible = Engine.is_editor_hint()
	
	body_entered.connect(__on_body_entered)
	body_exited.connect(__on_body_exited)



func _physics_process(delta: float) -> void:
	if not walk: return
	if not path: return
	
	global_position = _path_follow.global_position
	
	__follow_path(speed * delta)


#Следование по пути. Вызывается только, когда [b]walk==true[/b].
#Аргумент [b]step[/b] отвечает за длину шага вдоль прямой в текущем кадре физики.
func __follow_path(step:float):
	path_progress += step


#Игрок вошел в зону.
func __on_body_entered(body):
	if not body is Body: return
	_label.show()
	body.action_object = self


#Игрок вышел из зоны.
func __on_body_exited(body):
	if not body is Body: return
	_label.hide()
	body.action_object = null


func __on_screen_entered():
	screen_entered.emit()


func __on_screen_exited():
	screen_exited.emit()


##Вызов событий связанных с взаимодействием с этим NPC.
func action():
	pass


##Сказать случайную фразу из списка [member speech_lines].
func say():
	var speech:SpeechLine
	while true:
		speech = speech_lines.pick_random()
		if not speech: return
		if speech.roll_chance():
			speech = speech
			break
	
	if speech:
		_speech_bubbble.text = speech.text
		_speech_bubbble.show_time = speech.time


##Узнать, находится ли NPC на экране.
func is_on_screen() -> bool:
	assert(visible_enabler != null, "Попытка узнать видимость камерой NPC с отсутвующим VisibleOnScreenEnabler2D.")
	return visible_enabler.is_on_screen() if visible_enabler else false
