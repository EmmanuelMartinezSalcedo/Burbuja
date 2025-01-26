extends CharacterBody2D
class_name Entity

@export var volume: float  # Volumen del jugador
@export var density: float  # Densidad del jugador (ajustable según el objeto)
@export var speed: float  # Velocidad base de movimiento del jugador
@export var max_speed: float  # Límite máximo de velocidad
@export var health: float
@export var damage: float

const gravity = 10  # Gravedad
const water_density = 2  # Densidad del agua

var damage_scene = preload("res://Scenes/damage.tscn")

var momentum_x = 0.97
var momentum_y = 0.95

# Llamar a la fuerza hidrostática
func hydrostatic_force(value: float) -> float:
	return value * gravity * water_density

# Calcular el peso
func weight() -> float:
	return volume * density * gravity
