class_name StartItemConfig
extends Object

const MOD_ID = "HollowBamboo-StartItems"
const DEFAULT_CONFIG = {
	"items": 3,
	"out_of_max": true,
	"number_of_enemies_by_common": 10,
	"number_of_enemies_by_uncommon": 10,
	"number_of_enemies_by_rage": 10,
	"number_of_enemies_by_legendary": 10,
}

static func get_current_config() -> Dictionary:
	return DEFAULT_CONFIG
#	var config = ModLoader.get_mod_config(MOD_ID, "DEFAULT")
#	if config == null:
#		return DEFAULT_CONFIG
#	return config.data


