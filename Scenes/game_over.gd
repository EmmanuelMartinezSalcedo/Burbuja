extends Node2D

var map_scene = preload("res://Scenes/map.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(map_scene)


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
