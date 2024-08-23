@tool
extends Quest
##Квест со счетчиком. Автоматически меняет свой статус на [member Quest.Status.COMPLETED].
##Имеет [member value] и [member max_value] для установки текущего и максимального значения соответсвенно.
class_name QuestCounter


##Текущее значение счетчика. При достижении значения равного [member max_value], меняет статус на [member Quest.Status.COMPLETED].
@export_range(0, 1000, 1) var value:int:
	set(v):
		_data["value"] = clamp(v, 0, max_value)
		if v >= max_value and not Engine.is_editor_hint():
			set_status(Status.COMPLETED)
		changed_value.emit()
		data_changed.emit()
	get:
		return _data.get("value",0)
##Максимальное значение счетчика.
@export_range(0, 1000, 1) var max_value:int:
	set(v):
		max_value = v
		value = value
		data_changed.emit()


##Изменение счетчика.
signal changed_value


##Увеличить значение [member value] на 1.
func incrase():
	value += 1


##Уменьшить значение [member value] на 1.
func decrase():
	value -= 1


##Получить отформатированное название квеста с применением BBCode тэгов.
func format_title() -> String:
	var result = ""
	result = _PATTERN.format({
		"title": title + "({value}/{max})".format({
			"value": value,
			"max": max_value,
		}),
		"desc": description,
		"color": "green" if get_status() == Quest.Status.COMPLETED else "white",
	})
	set_meta("title_format", result)
	return result
