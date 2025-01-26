extends Node2D

var shop_reference : Node2D

func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body.has_method("user_input"):
		print("Open Shop")
