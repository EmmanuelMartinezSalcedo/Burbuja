extends Fish

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Aquí asignamos valores a las propiedades heredadas de `Entity` si es necesario
	volume = 70.0
	density = 1.90
	speed = 10.0
	max_speed = 200.0
	pass

func _process(delta: float) -> void:

	var buoyant_force = hydrostatic_force(volume)  # Fuerza hacia arriba
	var body_weight = weight()  # Fuerza hacia abajo

	var net_force = buoyant_force - body_weight

	velocity.y -= net_force * delta

	# Límite de velocidad
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

	position += velocity * delta
