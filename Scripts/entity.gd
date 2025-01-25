extends CharacterBody2D
class_name Entity

var volume: float  # Volumen del jugador
var density: float  # Densidad del jugador (ajustable según el objeto)
var speed: float  # Velocidad base de movimiento del jugador
var max_speed: float  # Límite máximo de velocidad
var health: float
var damage: float

const gravity = 10  # Gravedad
const water_density = 2  # Densidad del agua

var momentum_x = 0.97
var momentum_y = 0.95

# Llamar a la fuerza hidrostática
func hydrostatic_force(value: float) -> float:
	return value * gravity * water_density

# Calcular el peso
func weight() -> float:
	return volume * density * gravity
