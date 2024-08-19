extends Resource
##Вспомогательный класс для хранения случайной фразы [NPC].
class_name SpeechLine

static var _randomizer:RandomNumberGenerator = RandomNumberGenerator.new()

##Шанс, что это фраза будет использована. (Пока что не реализовано.)
@export_range(0, 1, 0.01) var chance:float = 1.0
##Веремя в секундах, которое эта фраза пробудет на экране.
@export var time:float = 3.0
##Текст фразы.
@export_multiline var text:String


## На основе [param chance], получить разрешение использовать эту фразу.
func roll_chance() -> bool:
	_randomizer.randomize()
	#FIXME Рандом всегда 50/50
	var result = _randomizer.randf_range(0.0, 1.0)
	return result <= chance
