extends Node2D

var volume: float = 70.0  # Volumen del jugador
var density: float = 1.99  # Densidad del jugador (ajustable según el objeto)
var speed: float = 5.0  # Velocidad base de movimiento del jugador
var velocity = Vector2()  # Dirección de movimiento
var gravity = 10  # Gravedad
var water_density = 2  # Densidad del agua
var max_speed: float = 50.0  # Límite máximo de velocidad

var momentum_x = 0.97
var momentum_y = 0.95
var friction = 0.98

var can_follow_player = false
var player_position = Vector2()  # Posición del jugador (debería ser actualizada en algún lugar)

# Llamar a la fuerza hidrostática
func hydrostatic_force(value: float) -> float:
	return value * gravity * water_density

# Calcular el peso
func weight() -> float:
	return volume * density * gravity

# Atraer la burbuja hacia el jugador
func attract_to_player(delta: float) -> void:
	if can_follow_player:
		var direction_to_player = (player_position - position).normalized()  # Dirección hacia el jugador
		var attraction_strength = 10000.0
		velocity = direction_to_player * attraction_strength * delta * 10 # Mover

func _ready() -> void:
	pass



func _process(delta: float) -> void:
	var player = get_parent().get_child(0)  # Suponiendo que el jugador es el primer hijo del contenedor
	player_position = player.position  # Actualizar la posición del jugador cada frame
	# Podriamos aprovechar esto para hacer una flecha que los una

	# Calcular la fuerza de flotación y peso de la burbuja
	var buoyant_force = hydrostatic_force(volume)  # Fuerza hacia arriba
	var body_weight = weight()  # Fuerza hacia abajo

	# La gravedad y flotación siempre se aplican
	var net_force = buoyant_force - body_weight

	# Controlar si la burbuja sigue al jugador
	if can_follow_player and Input.is_action_pressed("ui_accept"):
		velocity = Vector2()
		attract_to_player(delta)
	else:
		velocity *= friction

	# Límite de velocidad
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

	velocity.y -= net_force

	position += velocity * delta
