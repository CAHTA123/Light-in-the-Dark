@tool
extends Resource
## Общий класс для создания квеста.
class_name Quest

enum Status {
	NOT_ACTIVE, ##Квест не активен. Информация скрыта. Используется для хранения невыданных квестов.
	ACTIVE, ##Квест активен. Информация о нем отображается в журнале и ведется учет событий квеста. Автоматически присваивается всем новым квестам.
	COMPLETED, ##Квест завершен. Информация доступна в журнале. Учет событий не ведется.
	FAILED, ##Квест провален. Информация доступна в журнале. Учет событий не ведется.
}

const _PATTERN:String = "[color={color}][b]{title}[/b][/color]\n\t - [i]{desc}[/i]\n"

#Уникальный ID квеста.
var _id:StringName
##Отображаемое название.
@export_multiline var title:String
##Отображаемое описание.
@export_multiline var description:String
#Текущий статус квеста. Подробнее [member Quest.Status]
var _status:Status:
	set(value):
		_data["status"] = value
	get:
		return _data.get("status", Status.NOT_ACTIVE)
var _data:Dictionary = {}

##Изменение статуса квеста.
signal status_changed(status:Status)
##Данные квеста изменены. Это включает в себя статус и иные внутренние переменные требующие отслеживания.
signal data_changed


##Текущий статус квеста. Подробнее [member Quest.Status]
func get_status() -> Status:
	return _status


##Изменить статус квеста принудительно. Подробнее о статусах [member Quest.Status].
func set_status(status:Status, need_emit_signal:bool = true):
	_status = status
	
	if need_emit_signal:
		data_changed.emit()
		status_changed.emit(get_status())


##Получить отформатированное название квеста с применением BBCode тэгов.
func format_title() -> String:
	var result = get_meta("title_format", "")
	if len(result) == 0:
		result = _PATTERN.format({
		"title": title,
		"desc": description,
		"color": "green" if get_status() == Quest.Status.COMPLETED else "white",
		})
		set_meta("title_format", result)
	return result


##Уникальный ID квеста в [QuestManager]. Обычно, в качестве ID выступает имя файла ресурса,
##поскольку идет расчет, что все квесты лежат в одной папке [member QuestManager.DIR_QUEST_DATA], следовательно,
##одинаковых имен файлов быть не может.
func get_id() -> StringName:
	return _id


##Активировать квест.
func activate():
	set_status(Quest.Status.ACTIVE)


##Завершить квест.
func complete():
	set_status(Quest.Status.COMPLETED)


##Провалить квест.
func fail():
	set_status(Quest.Status.FAILED)
