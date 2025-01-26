extends Node2D

var shop_scene : PackedScene = preload("res://Scenes/shop.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("user_input"):
		var c = CanvasLayer.new()
		get_parent().add_child(c)
		var s = shop_scene.instantiate()
		c.add_child(s)
		call_deferred("queue_free")
		
