extends Node
##Менеджер квестов. Позволяет отслеживать статусы квестов и информировать об их выполнении.
##При каждом запуске автоматически добавляет все квесты из [member DIR_QUEST_DATA] и присваивает им статус [member Quest.Status.NOT_ACTIVE].
##Все квесты хранятся под уникальным ID, в качестве которого выступает имя файла.
class_name QuestManager


##Директория содержащая квесты.
const DIR_QUEST_DATA := "res://data/quests/"
##Файл для сохранения данных квестов.
const FILE_SAVED_DATA := "user://quest.data"
var _quest_list:Dictionary = {}


##Статус отслеживаемого квеста изменен на [member Quest.Status.COMPLETED].
signal quest_completed(quest:Quest)
##Статус отслеживаемого квеста изменен на [member Quest.Status.ACTIVATED].
signal quest_activated(quest:Quest)
##Статус отслеживаемого квеста изменен на [member Quest.Status.FAILED].
signal quest_failed(quest:Quest)

##Данные квеста изменены. Это включает в себя статус и иные внутренние переменные требующие отслеживания.
signal quest_data_changed(quest:Quest)


func _ready() -> void:
	print('[QuestManager]: Начинаю чтение квестов в "{dir}".'.format({'dir': DIR_QUEST_DATA}))
	assert(DirAccess.dir_exists_absolute(DIR_QUEST_DATA), 'Дирректория "{dir}" не существует! Невозможно прочитать квесты."'.format({"dir":DIR_QUEST_DATA}))
	
	#Прочитываем все существующие квесты с их базовыми значениями.
	for file in DirAccess.get_files_at(DIR_QUEST_DATA):
		var full_path := DIR_QUEST_DATA.path_join(file)
		var res = load(full_path)
		if not res is Quest:
			assert(false, 'Ресурс "path" не является обектом Quest. Рекомендуется его удалить или переместить в иное место.'.format({'path':full_path}))
			continue
		res._id = file.get_basename()
		res.set_status(Quest.Status.NOT_ACTIVE, false)
		_add_quest(res)
	print('[QuestManager]: Прочитано {count} квестов.'.format({'count': len(get_list())}))
	process_mode = Node.PROCESS_MODE_DISABLED
	
	#Отслеживание закрытия окна игры для сохранения данных квеста.
	Engine.get_main_loop().root.close_requested.connect(save_data)
	
	#Перезапись значений и статусов квестов используя сохраненные данные.
	load_data()
	#Попытка сохранить данные, для создания файла сохранения.
	save_data()


#Добавить квест в список.
func _add_quest(quest:Quest):
	if not quest: return
	assert(not _quest_list.get(quest.get_id()), "Квест \"{id}\" уже есть в списке. Игнорирование этой ошибки приведет к замене квеста на новый и возможному возникновению новых.".format({
		"id": quest.get_id()
	}))
	_quest_list[quest.get_id()] = quest
	
	quest.status_changed.connect(func(status:Quest.Status):
		match status:
			Quest.Status.ACTIVE:	quest_activated.emit(quest)
			Quest.Status.COMPLETED:	quest_completed.emit(quest)
			Quest.Status.FAILED:	quest_failed.emit(quest)
		)
	quest.data_changed.connect(emit_signal.bind("quest_data_changed", quest))
	print('[QuestManager]: Добавлен квест ID:{id}'.format({'id': quest.get_id()}))


#Полностью удалить квест из менеджера.
func _remove_quest(id:StringName):
	var quest := get_quest(id)
	assert(quest, "Квест \"{id}\" отсутствует в списке. Невозможно удалить.".format({
		"id": id
	}))
	_quest_list.erase(quest.get_id())


##Получить квест по ID. 
func get_quest(id:StringName) -> Quest:
	assert(_quest_list.get(id), "Квест \"{id}\" отсутствует в списке.".format({
		"id": id
	}))
	return _quest_list.get(id)


##Получение квестов игрока. По умолчанию, возвращает все квесты.
##Получить список имеющий определенный статус можно используя аргумент [param status].
##Подробнее о статусах [member Quest.Status].
func get_list(status:Quest.Status = -1) -> Array[Quest]:
	var list:Array[Quest]
	list.append_array(_quest_list.values())
	if status > -1:
		assert(Quest.Status.values().has(status), "Статус квеста \"{status}\" не существует. Функция вернет пустой список.".format({"status":status}))
		list = list.filter(func(quest:Quest): return quest.get_status() == status)
	
	return list


##Сохранить прогресс квестов.
func save_data():
	var dir_path := ProjectSettings.globalize_path(FILE_SAVED_DATA.get_base_dir())
	var file_path := ProjectSettings.globalize_path(FILE_SAVED_DATA)
	var err = DirAccess.make_dir_recursive_absolute(dir_path)
	
	#Проверка доступности директории.
	if err != OK:
		var err_str := '[QuestManager]: Невозможно получить доступ к директории "{dir}" для сохранения данных квестов. ({err})'.format({
			'dir': dir_path,
			'err': error_string(err),
		})
		printerr(err_str)
		assert(false, err_str)
		return
	
	#Открытие/создание файла и проверка на ошибки записи.
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		var err_str := '[QuestManager]: Невозможно получить доступ к файлу "{file_path}" для сохранения данных квестов.'.format({
			'file_path': file_path,
		})
		printerr(err_str)
		assert(false, err_str)
		return
	
	#Создание словаря для каждого квеста и копирование в него данных квеста.
	var data := {}
	for key in _quest_list.keys():
		data[key] = get_quest(key)._data
	
	#Запись словаря в файл.
	file.store_string(JSON.stringify(data, "\t"))
	
	#Принудительное сохранение файла.
	file.flush()
	print('[QuestManager]: Успешное сохранение данных квестов в файл "{file_path}"'.format({
		"file_path": file_path
	}))


##Прочитать сохраненный прогресс квестов.
func load_data():
	var dir_path := ProjectSettings.globalize_path(FILE_SAVED_DATA.get_base_dir())
	var file_path := ProjectSettings.globalize_path(FILE_SAVED_DATA)
	var err = DirAccess.make_dir_recursive_absolute(dir_path)
	
	#Проверка доступности директории.
	if err != OK:
		var err_str := '[QuestManager]: Невозможно прочитать директорию "{dir}" для получения данных квестов. ({err})'.format({
			'dir': dir_path,
			'err': error_string(err),
		})
		printerr(err_str)
		return
	
	#Открытие файла и проверка на ошибки чтения.
	var file := FileAccess.open(file_path, FileAccess.READ)
	if not file:
		var err_str := '[QuestManager]: Невозможно прочитать файл "{file_path}" с данными квестов.'.format({
			'file_path': file_path,
		})
		printerr(err_str)
		return
	
	#Чтение записанного в файл словаря и применение к существующим квестам.
	var parsed_dict = JSON.parse_string(file.get_as_text())
	var data:Dictionary = parsed_dict if parsed_dict else {}
	for key in data.keys():
		var quest:Quest = get_quest(key)
		if not quest: return
		quest._data = data[key]
	
	print('[QuestManager]: Успешное чтение данных квестов из файла "{file_path}"'.format({
		"file_path": file_path
	}))
