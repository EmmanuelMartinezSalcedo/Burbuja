extends Control

@export var item_id_1: int = 0
@export var item_id_2: int = 0
@export var item_id_3: int = 0

var first_item: Node
var second_item: Node
var third_item: Node

var item_names: Array[String] = [
"Super Bullets", 
"Sharper Knife", 
"Sun Screen", 
"Weapon Expertise", 
"Bubble Sort", 
"Air Refill", 
"Surface Tension"]
var items_description: Array[String] = [
"Pistol has +10% increase Damage", 
"Knife has +10% increase Damage", 
"Fully healths the Diver", 
"Weapons have +4% increase Damage", 
"Bubble has +10% increase maximum health", 
"Fully healths the Bubble", 
"Bubble receives -10% Damage"]

func _ready() -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	
	var item_id_1 = rng.randi_range(1, 7)

	var item_id_2 = rng.randi_range(1, 7)
	while item_id_2 == item_id_1:
		item_id_2 = rng.randi_range(1, 7)

	var item_id_3 = rng.randi_range(1, 7)
	while item_id_3 == item_id_1 or item_id_3 == item_id_2:
		item_id_3 = rng.randi_range(1, 7)
		
	$Control/Item1/Title1.text = item_names[item_id_1 - 1]
	$Control/Item2/Title2.text = item_names[item_id_2 - 1]
	$Control/Item3/Title3.text = item_names[item_id_3 - 1]
	
	$Control/Item1/Description1.text = items_description[item_id_1 - 1]
	$Control/Item2/Description2.text = items_description[item_id_2 - 1]
	$Control/Item3/Description3.text = items_description[item_id_3 - 1]
	
	var parent_node = $Purchaseable_Items/MarginContainer/HBoxContainer
	
	var item_ids: Array[int] = [item_id_1, item_id_2, item_id_3]
	
	var item_scene: PackedScene = load("res://Scenes/item.tscn")
	
	for item_id in item_ids:
		var item_instance: TextureRect = item_scene.instantiate()
		item_instance.loadInfo(item_id)
		parent_node.add_child(item_instance)
	
	first_item = parent_node.get_child(0)
	second_item = parent_node.get_child(1)
	third_item = parent_node.get_child(2)
	
	first_item.selected = true
	update_selector_position(first_item)
	update_selector_position(first_item)
	update_selector_position(first_item)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		if first_item.selected == true:
			first_item.selected = false
			second_item.selected = true
			update_selector_position(second_item)
		elif second_item.selected == true:
			second_item.selected = false
			third_item.selected = true
			update_selector_position(third_item)
		elif third_item.selected == true:
			third_item.selected = false
			first_item.selected = true
			update_selector_position(first_item)
	elif event.is_action_pressed("ui_left"):
		if first_item.selected == true:
			first_item.selected = false
			third_item.selected = true
			update_selector_position(third_item)
		elif second_item.selected == true:
			second_item.selected = false
			first_item.selected = true
			update_selector_position(first_item)
		elif third_item.selected == true:
			third_item.selected = false
			second_item.selected = true
			update_selector_position(second_item)
	elif event.is_action_pressed("ui_accept"):
		print_selected_item()

func print_selected_item():
	if first_item.selected:
		print("El primer item está seleccionado.")
	elif second_item.selected:
		print("El segundo item está seleccionado.")
	elif third_item.selected:
		print("El tercer item está seleccionado.")
	else:
		print("Ningún item está seleccionado.")

func update_selector_position(selected_item: Node) -> void:
	$Selector.position = selected_item.global_position + Vector2(selected_item.size.x / 2, selected_item.size.y)
