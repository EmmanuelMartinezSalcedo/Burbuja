extends Node2D

var levels : Array[PackedScene] = [
	preload("res://Scenes/Levels/ooooo.tscn"),
	preload("res://Scenes/Levels/xxoxx.tscn"),
	preload("res://Scenes/Levels/xoxox.tscn"),
	preload("res://Scenes/Levels/xooox.tscn"),
	preload("res://Scenes/Levels/ooxoo.tscn")
]

var prob : Array[Array] = [
	[12, 22, 22, 22, 22],
	[38, 23, 0, 39, 0],
	[28, 0, 16, 28, 28],
	[22, 22, 22, 12, 22],
	[28, 0, 28, 28, 16]
]

var num_tiles : Array[int] = [24, 52, 51, 31, 31]

const tile_sz = 32
const to_generate = 7

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	var curr = 0
	var offset = 20 * tile_sz
	for l in range(to_generate):
		var r = rng.randi_range(0, 100)
		var acc = 0
		var j = 0
		for i in range(5):
			acc += prob[curr][i]
			if r <= acc:
				j = i
				break
		var node = levels[j].instantiate()
		node.get_children().pick_random().enabled = true
		node.position.y = offset;
		$Levels.add_child(node)
		#add_child(node)
		curr = j
		offset += tile_sz * num_tiles[j]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
