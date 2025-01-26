extends Entity

var bubble: CharacterBody2D = null  # La burbuja con la que interactuaremos
var invincible = false
var invincibility_timer = 0.0  # Temporizador para la invencibilidad
var invincibility_duration = 1.0  # Duración de la invencibilidad en segundos
var life_loss_interval = 2.0  # Intervalo en segundos para perder vida
var life_loss_amount = 1  # Cantidad de vida que pierde el jugador en cada intervalo
var life_loss_timer = 0.0  # Temporizador para perder vida

@onready var health_indicator = $Label

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
	health_indicator.text = str(health)
	user_input()

	# Actualizar el temporizador de pérdida de vida
	life_loss_timer -= delta
	if life_loss_timer <= 0:
		# Perder vida y reiniciar el temporizador
		health -= life_loss_amount
		life_loss_timer = life_loss_interval  # Reiniciar el temporizador

	var buoyant_force = hydrostatic_force(volume)  # Fuerza hacia arriba
	var body_weight = weight()  # Fuerza hacia abajo

	var net_force = buoyant_force - body_weight

	velocity.y -= net_force * delta

	# Límite de velocidad
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

	move_and_slide()
	
	# Manejo del temporizador de invencibilidad
	if invincible:
		invincibility_timer -= delta
		if invincibility_timer <= 0:
			invincible = false  # Desactivar la invencibilidad
	
	if health <= 0:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bubble"):
		bubble = area.get_parent()  # Guarda la referencia a la burbuja
		bubble.can_follow_player = true
	if area.is_in_group("enemy") and not invincible:
		health -= area.get_parent().damage
		# Activamos invencibilidad
		invincible = true
		invincibility_timer = invincibility_duration  # Reiniciamos el temporizador

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("bubble"):
		bubble.can_follow_player = false
		bubble = null  # Borramos la referencia a la burbuja cuando salimos del área
