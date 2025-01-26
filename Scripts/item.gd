extends TextureRect

@export var selected: bool = false

func _input(event: InputEvent) -> void:
	pass

func loadInfo(id: int) -> void:
	var texture_path: String = find_upgrade_texture_path(id)
	if texture_path != "":
		texture = load(texture_path)
	
func find_upgrade_texture_path(item_id: int) -> String:
	var upgrades_folder: String = "res://Sprites/Upgrades/"
	var dir: DirAccess = DirAccess.open(upgrades_folder)
	if dir == null:
		return ""
	
	dir.list_dir_begin()
	while true:
		var filename: String = dir.get_next()
		if filename == "":
			break
		if filename.begins_with(str(item_id) + "-") and filename.ends_with(".png") and not dir.current_is_dir():
			return upgrades_folder + filename
	
	dir.list_dir_end()
	return ""

func activate() -> void:
	pass
