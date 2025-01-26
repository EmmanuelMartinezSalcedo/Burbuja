extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

const BULLET = preload("res://Scenes/bullet.tscn")

# Variables para el cooldown
var fire_cooldown: float = 0.0  # Tiempo restante para el cooldown del disparo
var fire_cooldown_duration: float = 0.5  # Duración del cooldown entre disparos (en segundos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())

	rotation_degrees = wrap(rotation_degrees, 0, 360)
	
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1 
		
	# Verificar si el cooldown ha terminado y si se presiona el botón de disparo
	if Input.is_action_just_pressed("fire") and fire_cooldown <= 0:
		fire_bullet()
		fire_cooldown = fire_cooldown_duration  # Reinicia el cooldown del disparo

	# Reducir el cooldown cada frame
	if fire_cooldown > 0:
		fire_cooldown -= delta

# Función para disparar la bala
func fire_bullet() -> void:
	var bullet_instance = BULLET.instantiate()
	get_tree().root.add_child(bullet_instance)
	# Nota: Arreglar la posición de la burbuja
	bullet_instance.global_position = global_position
	bullet_instance.rotation = rotation
