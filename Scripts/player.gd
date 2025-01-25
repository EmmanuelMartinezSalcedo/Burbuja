extends Node2D

var volume: float = 70.0  # Volumen del jugador
var density: float = 1.5  # Densidad del jugador (ajustable según el objeto)
var speed: float = 20.0  # Velocidad base de movimiento del jugador
var velocity = Vector2()  # Dirección de movimiento
var gravity = 10  # Gravedad
var water_density = 2  # Densidad del agua
var max_speed: float = 300.0  # Límite máximo de velocidad

var momentum_x = 0.97
var momentum_y = 0.95

# Llamar a la fuerza hidrostática
func hydrostatic_force(value: float) -> float:
	return value * gravity * water_density

# Calcular el peso
func weight() -> float:
	return volume * density * gravity

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	# Aqui cambiar los UI por lo que pusiste Emmanuel, no vi bien xd
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

	var buoyant_force = hydrostatic_force(volume)  # Fuerza hacia arriba
	var body_weight = weight()  # Fuerza hacia abajo

	var net_force = buoyant_force - body_weight

	velocity.y -= net_force * delta

	# Límite de velocidad
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

	position += velocity * delta

	print("Fuerza hidrostática: ", buoyant_force)
	print("Peso del cuerpo: ", body_weight)
	print("Fuerza neta: ", net_force)
