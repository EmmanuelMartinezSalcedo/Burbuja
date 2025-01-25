extends Entity


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:	
	volume = 70.0  # Volumen del jugador
	density = 1.9  # Densidad del jugador (ajustable según el objeto)
	speed = 10.0  # Velocidad base de movimiento del jugador
	max_speed = 250.0  # Límite máximo de velocidad
	momentum_x = 0.97
	momentum_y = 0.95
	
	health = 100
	damage = 100

func _process(delta: float) -> void:
	
	var buoyant_force = hydrostatic_force(volume)  # Fuerza hacia arriba
	var body_weight = weight()  # Fuerza hacia abajo

	var net_force = buoyant_force - body_weight

	velocity.y -= net_force * delta

	# Límite de velocidad
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	position += velocity * delta
	
