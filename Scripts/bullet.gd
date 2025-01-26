extends Node2D

var speed: float = 500.0  # Velocidad inicial
var deceleration: float = 300.0  # Factor de desaceleración
var damage: int = 50
var lifetime: float = 5.0  # Tiempo de vida antes de desaparecer (en segundos)
var time_alive: float = 0.0  # Tiempo transcurrido desde que el nodo comenzó a existir

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Reducir la velocidad gradualmente con el tiempo
	speed -= deceleration * delta  # La velocidad disminuye por deceleration cada frame

	# Asegurarse de que la velocidad no se vuelva negativa
	if speed < 0:
		speed = 0

	# Mover el nodo en la dirección de la transformación actual (hacia adelante)
	position += transform.x * speed * delta
	position.y -= 100 * delta  # Movimiento adicional en el eje Y (puedes ajustarlo si es necesario)

	# Incrementar el tiempo de vida
	time_alive += delta
	
	# Si el tiempo de vida excede el tiempo límite, eliminamos el nodo
	if time_alive >= lifetime:
		queue_free()  # Elimina el nodo de la escena
