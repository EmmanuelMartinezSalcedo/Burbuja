extends Entity

var bubble: CharacterBody2D = null  # La burbuja con la que interactuaremos
var invincible = false
var invincibility_timer = 0.0  # Temporizador para la invencibilidad
var invincibility_duration = 1.0  # Duración de la invencibilidad en segundos

func _ready() -> void:	
	volume = 70.0  # Volumen del jugador
	density = 1.7  # Densidad del jugador (ajustable según el objeto)
	speed = 10.0  # Velocidad base de movimiento del jugador
	max_speed = 90.0  # Límite máximo de velocidad
	momentum_x = 0.97
	momentum_y = 0.95
	
	health = 100.0

func user_input() -> void:
	# Movimiento del jugador
	if Input.is_action_pressed("ui_up"):  # W
		velocity.y -= speed
	elif Input.is_action_pressed("ui_down"):  # S
		velocity.y += speed
	else:
		velocity.y *= momentum_y

	if Input.is_action_pressed("ui_left"):  # A
		velocity.x -= speed
	elif Input.is_action_pressed("ui_right"):  # D
		velocity.x += speed
	else:
		velocity.x *= momentum_x

func _process(delta: float) -> void:
	
	user_input()
	
	var buoyant_force = hydrostatic_force(volume)  # Fuerza hacia arriba
	var body_weight = weight()  # Fuerza hacia abajo

	var net_force = buoyant_force - body_weight

	velocity.y -= net_force * delta

	# Límite de velocidad
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	position += velocity * delta
	
	# Manejo del temporizador de invencibilidad
	if invincible:
		# Aumentar el temporizador de invencibilidad
		invincibility_timer -= delta
		if invincibility_timer <= 0:
			invincible = false  # Desactivar la invencibilidad
	
	if health <= 0:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
	print("Player health: " + str(health))

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bubble"):
		bubble = area.get_parent()  # Guarda la referencia a la burbuja
		bubble.can_follow_player = true
	if area.is_in_group("enemy") and not invincible:
		print("Took damage: " + str(area.get_parent().damage))
		health -= area.get_parent().damage
		# Activamos invencibilidad
		invincible = true
		invincibility_timer = invincibility_duration  # Reiniciamos el temporizador


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("bubble"):
		bubble.can_follow_player = false
		bubble = null  # Borramos la referencia a la burbuja cuando salimos del área
