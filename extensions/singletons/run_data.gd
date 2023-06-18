extends "res://singletons/run_data.gd"

var _starting_items:Array = []
var _starting_items_config:Dictionary

func _ready():
	_starting_items.clear()

func reset(restart:bool = false)->void :
	.reset(restart)
	
	var StartItemConfig = load("res://mods-unpacked/HollowBamboo-StartItems/config.gd").new()
	var config = StartItemConfig.get_current_config()

	if restart:
		apply_starting_items()
	else:
		_starting_items.clear()
		
		
func add_starting_item(item:ItemData)->void :
	_starting_items.append(item)

func apply_starting_items()->void:
	
	var common = 10
	if _starting_items_config.has("number_of_enemies_by_common"):
		common = int(_starting_items_config.number_of_enemies_by_common)
	
	var uncommon = 10
	if _starting_items_config.has("number_of_enemies_by_uncommon"):
		uncommon = int(_starting_items_config.number_of_enemies_by_uncommon)
	
	var rage = 10
	if _starting_items_config.has("number_of_enemies_by_rage"):
		rage = int(_starting_items_config.number_of_enemies_by_rage)
		
	var legendary = 10
	if _starting_items_config.has("number_of_enemies_by_legendary"):
		legendary = int(_starting_items_config.number_of_enemies_by_legendary)
	
	for item in _starting_items:
		add_item(item)
		
		if ItemData.Tier.COMMON == item.tier:
			RunData.add_stat("number_of_enemies", common)
			
		elif ItemData.Tier.UNCOMMON == item.tier:
			RunData.add_stat("number_of_enemies", uncommon)
			
		elif ItemData.Tier.RARE == item.tier:
			RunData.add_stat("number_of_enemies", rage)

		else:
			RunData.add_stat("number_of_enemies", legendary)

