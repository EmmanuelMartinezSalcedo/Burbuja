extends Entity

var is_following_player = false
var player: CharacterBody2D = null  # The player entity
var invincible = false  # Estado de invencibilidad
var invincibility_duration = 1.0  # Duración de la invencibilidad en segundos
var invincibility_timer = 0.0  # Temporizador para la invencibilidad

var draining = false

func _ready() -> void:
	volume = 7.0  # Volumen del jugador
	density = 1  # Densidad del jugador (ajustable según el objeto)
	speed = 20.0  # Velocidad base de movimiento del jugador
	max_speed = 50.0  # Límite máximo de velocidad
	momentum_x = 0.97
	momentum_y = 0.95
	health = 200.0

func user_input(delta: float) -> void:
	if is_following_player and player and Input.is_action_pressed("ui_accept"):
		# Calculate direction to the player
		var direction_to_player = (player.position - position).normalized()
		var attraction_strength = 10000.0  # Attraction strength toward the player
		velocity += direction_to_player * attraction_strength * delta * 0.1  # Move toward the player

func _process(delta: float) -> void:
	scale = Vector2(volume * 0.1, volume  * 0.1) * health / 100
	# Apply buoyant force (float up/down based on buoyancy)
	var buoyant_force = hydrostatic_force(volume)  # Fuerza hacia arriba
	var body_weight = weight()  # Fuerza hacia abajo
	var net_force = buoyant_force - body_weight
	velocity.y -= net_force * delta  # Adjust vertical velocity based on buoyant force

	# Get user input (follow the player if inside the area)
	user_input(delta)

	# Limit the speed of the entity to prevent excessive movement
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	
	# Apply momentum for smooth deceleration (if needed)
	velocity.x *= momentum_x
	velocity.y *= momentum_y

	# Update position based on velocity
	#position += velocity * delta
	move_and_slide()

	# Manejo del temporizador de invencibilidad
	if invincible:
		# Aumentar el temporizador de invencibilidad
		invincibility_timer -= delta
		if invincibility_timer <= 0:
			invincible = false  # Desactivar la invencibilidad
	
	if draining and player:
		player.health += 1
		health -= 1
		if player.health >= 100:
			draining = false
	
	if health <= 0:
		# Cargar la escena de Game Over
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

func _on_grabbable_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		player = area.get_parent()
		is_following_player = true
		player = area.get_parent()  # Get the actual player node if needed

func _on_grabbable_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_following_player = false
		player = null  # Reset the player reference

func _on_hitbox_2_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		player = area.get_parent()
		if area.get_parent().health < 100:
			draining = true
			
			pass
		is_following_player = true
		player = area.get_parent()  # Get the actual player node if needed
	
	if area.is_in_group("enemy") and not invincible:
		print("Took damage: " + str(area.get_parent().damage))
		health -= area.get_parent().damage
		# Activamos invencibilidad
		invincible = true
		invincibility_timer = invincibility_duration  # Reiniciamos el temporizador
