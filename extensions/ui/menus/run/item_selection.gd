class_name ItemSelection
extends CharacterSelection

onready var _anyweapon_main_container:MarginContainer = $MarginContainer
onready var _showItemDescriptionContainer:HBoxContainer = $MarginContainer/VBoxContainer/DescriptionContainer

var next_scene = MenuData.real_difficulty_selection_scene

var MOD_ID = "HollowBamboo-StartItems"
var _selected_items:Array = []
var _item_info_panels:Array = []

# config.items: Maximum number of selectable items
# config.out_of_max: Break the maximum limit.
var config:Dictionary = {}

func _ready()->void :

	var StartItemConfig = load("res://mods-unpacked/HollowBamboo-StartItems/config.gd").new()
	config = StartItemConfig.get_current_config()

	_anyweapon_adjust_margins()
	_anyweapon_reset_columns()

	_info_panel.hide()
	_selected_items = []
	_item_info_panels = []

	random_icon = load("res://items/global/random_icon.png")
	_inventory.add_special_element(random_icon, true, 1, random_icon)
	var node = _inventory.get_child(_inventory.get_child_count() - 1)
	_inventory.move_child(node, 1)
	
	var skip_icon = load("res://ui/menus/run/difficulty_selection/difficulty_icons/endless.png")
	_inventory.get_child(0).icon = skip_icon
	
	
func get_elements_unlocked()->Array:
	
	return ProgressData.items_unlocked


func manage_back(event:InputEvent)->void :
	if event.is_action_pressed("ui_cancel"):
		if _selected_items.size() > 0:
			_selected_items.pop_back()
			_showItemDescriptionContainer.remove_child(_item_info_panels.pop_back())
		else:
			if RunData.effects["weapon_slot"] == 0:
				RunData.apply_weapon_selection_back()
			else :
				var _error = get_tree().change_scene(MenuData.weapon_selection_scene)


func get_all_possible_elements()->Array:
	var items = []
	for item in ItemService.items:
		if not "weapon_id" in item:
			items.append(item)
	return items


func get_reward_type()->int:
	return RewardType.ITEM


func on_element_pressed(element:InventoryElement)->void :
	if _selected_items.size() >= int(config.items):
		return 
		
	var item = null
	var skip = false
	if element.is_random:
		if element.item == null:
			skip = true
		else:
			item = Utils.get_rand_element(available_elements)
	else:
		item = element.item

	select_item(item)
	if _selected_items.size() >= int(config.items) || skip:
		add_items_to_run_data()
		var _error = get_tree().change_scene(next_scene)


func select_item(item:ItemData) -> void:
	if item == null:
		return
	
	# check number of item
	if item.max_nb > 0 && not config.out_of_max:
		var nb = RunData.get_nb_item(item.my_id)
		for item_tmp in _selected_items:
			if item_tmp.my_id == item.my_id:
				nb += 1
		if nb >= item.max_nb:
			return
	
	_selected_items.append(item)
	var new_item_panel = load("res://ui/menus/ingame/item_panel_ui.tscn").instance()
	_showItemDescriptionContainer.add_child(new_item_panel)
	new_item_panel.set_data(item)
	_item_info_panels.append(new_item_panel)
	_showItemDescriptionContainer.move_child(new_item_panel, _selected_items.size() - 1)


func add_items_to_run_data() -> void:
	for item in _selected_items:
		if not item == null:
			RunData.add_starting_item(item)
	RunData.apply_starting_items()
	
	
func update_info_panel(_item_info:ItemParentData)->void :
	pass


func is_char_screen()->bool:
	return false


func is_locked_elements_displayed()->bool:
	return false

# Use the code in Darkly77-WiderCharacterSelect because it doesn't take effect when work with this mod.
func _anyweapon_adjust_margins()->void:
	_anyweapon_main_container.set_margin(MARGIN_TOP, -60) # set it to -60 to ensure consistency with widerGUI.


func _anyweapon_reset_columns()->void:
	_inventory.columns = 17 # max: 17 in one row.
