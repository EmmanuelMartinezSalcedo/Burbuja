extends Node2D

var damage: float = 100
@onready var animationPlayer = $AnimationPlayer
@onready var original_rotation = rotation  # Guardamos la posición inicial

func _ready() -> void:
	pass

# Llamado en cada frame
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("slash"):
		print("Slash")
		if not animationPlayer.is_playing():  # Evita que la animación se inicie si ya está en curso
			animationPlayer.play("slash")
	

# Cuando la animación termina, movemos el personaje a su posición original
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "slash":
		rotation = original_rotation  # Regresamos a la posición inicial
