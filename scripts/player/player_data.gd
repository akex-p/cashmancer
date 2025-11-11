extends Resource
class_name PlayerData

var name: String
var mana_max: int
var mana_cur: int
var gold_cur: int

signal mana_changed
signal gold_changed

# init
func PlayerData(_name: String, _mana_max: int):
	name = _name
	mana_max = _mana_max

# modify
func modify_mana(amount: int) -> bool:
	var sum: int = mana_cur + amount
	if (mana_max > sum && sum > 0):
		mana_cur += amount
		mana_changed.emit()
		return true
	else:
		return false

func modify_gold(amount: int) -> void:
	gold_cur += amount
	gold_changed.emit()
