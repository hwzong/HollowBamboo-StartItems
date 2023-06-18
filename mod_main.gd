extends Node

const MOD_ID = "HollowBamboo-StartItems"
const MOD_DIR = "HollowBamboo-StartItems/"
const LOG = "HollowBamboo-StartItems"

var dir = ""
var ext_dir = ""
var ModsConfigInterface

func _init(modLoader = ModLoader):
	ModLoaderUtils.log_info("Init", LOG)
	dir = modLoader.UNPACKED_DIR + MOD_DIR
	ext_dir = dir + "extensions/"
	
	# Add extensions
	modLoader.install_script_extension(ext_dir + "singletons/menu_data.gd")
	modLoader.install_script_extension(ext_dir + "singletons/run_data.gd")

	# Add translations
	var transDir = dir + "translations/";
	modLoader.add_translation_from_resource(transDir + "start_items_text.en.translation")
	modLoader.add_translation_from_resource(transDir + "start_items_text.zh.translation")


func _ready():
#	var configs = ModLoaderConfig.get_current_config(MOD_ID)
#	if configs == null:
#		configs = ModLoaderConfig.get_default_config(MOD_ID)
#
#	# Create a current version profile
#	if configs.name == ModLoaderConfig.DEFAULT_CONFIG_NAME:
#		var mod = ModLoader.mod_data[MOD_ID]
#		var version = str(mod.manifest.version_number)
#		var save_path = "user://configs/" + MOD_ID + "/" + version + ".json"
#		var current_configs = ModConfig.new(MOD_ID, configs.data.duplicate(), save_path, configs.schema)
#		if current_configs.save_to_file():
#			ModLoaderUtils.log_info("Save new Config file [" + save_path + "] successful!", MOD_ID)
#			ModLoaderConfig.set_current_config(current_configs)

	ModsConfigInterface = get_node_or_null("/root/ModLoader/dami-ModOptions/ModsConfigInterface")
	if ModsConfigInterface != null:
		# for st in settings:
		#	ModsConfigInterface.on_setting_changed(st,settings[st],my_mod_name)
		ModsConfigInterface.connect("setting_changed", self, "_etting_changed")
	else:
		print_debug("ModsConfigInterface not Found")
		
	ModLoaderUtils.log_info("Done", LOG)
	

func _etting_changed(key,value,mod_name):
	if mod_name == MOD_ID:
		var configs_path = ModLoaderUtils.get_local_folder_dir("configs")
		var config = ModLoader.get_mod_config(MOD_ID, "").data;
		var save_file = File.new()
		var _error = save_file.open(configs_path.plus_file(MOD_ID + ".json"), File.WRITE)
		save_file.store_line(to_json(config))
		save_file.close()
		ModLoaderUtils.log_info("config save success as :" + configs_path.plus_file(MOD_ID + ".json"), LOG)
