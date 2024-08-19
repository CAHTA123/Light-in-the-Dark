extends Resource
class_name ShopItems

var _list:Dictionary

##TODO Типизировать item, для избежания попадание лишнего.


##Добавить предмет в список товаров.
func add_item(item, price:int):
	_list[item] = price


##Получить список товаров.
func get_items() -> Array:
	return _list.keys()


##Получить цену на товар. Если предмет отстутствует в продаже, то возвращает [param -1].
func get_price(item) -> int:
	assert(_list.has(item), "Попытка получить цену на товар, которого нет в списке.")
	return _list.get(item, -1)


##Удалить предмет из списка товаров.
func remove_item(item):
	_list.erase(item)
