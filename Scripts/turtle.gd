extends Entity

const SPEED = 200.0  # Velocidad base de movimiento
var bubble: Entity = null  # Referencia a la burbuja
var direction_to_bubble: Vector2  # Dirección hacia la burbuja
var bubble_position: Vector2  # Posición de la burbuja

@onready var animSprite = $AnimatedSprite2D

func _ready() -> void:
	animSprite.play("attack")
	volume = 70.0  # Volumen del jugador
	density = 1.9  # Densidad del jugador (ajustable según el objeto)
	speed = 0.5  # Velocidad base de movimiento
	max_speed = 50.0  # Límite máximo de velocidad
	momentum_x = 0.97
	momentum_y = 0.95
	
	health = 300
	damage = 30

	# Asegúrate de que la burbuja esté correctamente asignada antes de mover el pez.
	bubble = get_parent().get_node("Bubble")  # Ajusta la ruta al nodo de la burbuja
	
	# Calcular la dirección hacia la burbuja cuando el pez se crea
	if bubble:
		direction_to_bubble = (bubble.position - position).normalized()  # Dirección hacia la burbuja

func _process(delta: float) -> void:
	
	# Mover el pez en la dirección hacia la burbuja
	velocity = direction_to_bubble * SPEED  # Movimiento hacia la burbuja
	
	# Rotar el pez para que apunte hacia la burbuja
	# Usamos el ángulo del vector dirección para rotar el pez
	rotation = direction_to_bubble.angle()  # Obtiene el ángulo del vector de dirección

	# Aplicar la fuerza hidrostática y el peso
	var buoyant_force = hydrostatic_force(volume)  # Fuerza hacia arriba
	var body_weight = weight()  # Fuerza hacia abajo

	var net_force = buoyant_force - body_weight

	velocity.y -= net_force * delta  # Afectar la velocidad en el eje Y por la fuerza neta

	# Límite de velocidad
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	
	# Actualizar la posición del pez
	position += velocity * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		# Obtiene el nodo del "bullet" y reduce la salud
		var bullet = area.get_parent()
		health -= bullet.damage
		
		print(bullet.damage)
		
		bullet.queue_free()
		if health <= 0:
			get_parent().remove_child(self)
			queue_free()
