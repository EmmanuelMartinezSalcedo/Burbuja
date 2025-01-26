extends Node2D

var damage: float = 100
@onready var animationPlayer = $AnimationPlayer
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_pressed("slash")):
		animationPlayer.play("slash")
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.get_parent().health -= damage
	print("Deal damage to enemy")
	pass # Replace with function body.
