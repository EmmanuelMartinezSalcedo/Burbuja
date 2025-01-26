extends Node

var shopOpened = false
var upgrade = null

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
