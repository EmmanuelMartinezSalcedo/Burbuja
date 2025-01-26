extends Node2D

const BULLET = preload("res://Scenes/bullet.tscn")
var cooldown_time = 0.2  # Tiempo de cooldown entre disparos en segundos
var cooldown_timer = 0.0  # Temporizador para el cooldown

# Lerp factor para hacer que el objeto siga lentamente al cursor
var rotation_speed = 5.0  # Cuanto más alto, más rápido seguirá el cursor

@export var player_reference : Node2D
@export var move_distance : float = 100.0  # Distancia que el jugador se moverá al disparar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Suaviza la rotación hacia el mouse
	var target_angle = (get_global_mouse_position() - global_position).angle()
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

	# Actualiza el temporizador de cooldown
	cooldown_timer -= delta
	
	# Si el mouse está en el lado opuesto, invierte el escalado
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1 
	
	# Disparo solo si el cooldown ha pasado
	if Input.is_action_just_pressed("fire") and cooldown_timer <= 0:
		# Crear la bala
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		# Posicionar la bala
		bullet_instance.global_position = global_position
		bullet_instance.rotation = rotation
		
		# Mover al jugador en la dirección opuesta al disparo
		var opposite_direction = fmod(rotation + PI, 2 * PI)  # Dirección opuesta (uso de fmod)
		player_reference.velocity += Vector2(cos(opposite_direction), sin(opposite_direction)) * move_distance
		
		# Reducir la salud del jugador
		player_reference.health -= 1
		
		# Reiniciar el cooldown
		cooldown_timer = cooldown_time
