extends Node

var shopOpened = false
var upgrade = null

var upgrades_counter: Array[int] = [0, 0, 0, 0, 0, 0, 0]

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if shopOpened:
		get_tree().paused = true
	if upgrade != null:
		print(upgrade)
		upgrade = null
		shopOpened = false
		get_tree().paused = false
