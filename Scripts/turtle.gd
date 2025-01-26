extends Entity

const SPEED = 200.0  # Velocidad base de movimiento
const DIRECTION_UPDATE_INTERVAL = 2.0  # Intervalo de tiempo en segundos para actualizar la dirección
var bubble: Entity = null  # Referencia a la burbuja
var direction_to_player: Vector2  # Dirección hacia el jugador
var bubble_position: Vector2  # Posición de la burbuja
var player  # Referencia al jugador

@onready var animSprite = $AnimatedSprite2D
var time_since_last_direction_update: float = 0.0  # Tiempo transcurrido desde la última actualización de dirección

func _ready() -> void:
	animSprite.play("attack")

	# Asegúrate de que el jugador esté correctamente asignado antes de mover la entidad
	#player = get_parent().get_node("Player")  # Ajusta la ruta al nodo del jugador
	
	# Inicializa la dirección hacia el jugador si el jugador está disponible
	#if player:
		#direction_to_player = (player.position - position).normalized()  # Dirección hacia el jugador

func _process(delta: float) -> void:
	# Actualizar el tiempo transcurrido desde la última actualización de dirección
	time_since_last_direction_update += delta
	
	# Si ha pasado el intervalo de tiempo, recalcular la dirección hacia el jugador
	if time_since_last_direction_update >= DIRECTION_UPDATE_INTERVAL:
		if player:
			direction_to_player = (player.position - position).normalized()  # Nueva dirección hacia el jugador
		time_since_last_direction_update = 0.0  # Resetear el temporizador

	# Mover la entidad en la dirección hacia el jugador
	velocity = direction_to_player * SPEED  # Movimiento hacia el jugador
	
	# Rotar la entidad para que apunte hacia el jugador
	rotation = direction_to_player.angle()  # Obtener el ángulo del vector de dirección

	rotation_degrees = wrap(rotation_degrees, 0, 360)

	# Aplicar la fuerza hidrostática y el peso (si es necesario)
	var buoyant_force = hydrostatic_force(volume)  # Fuerza hacia arriba
	var body_weight = weight()  # Fuerza hacia abajo

	var net_force = buoyant_force - body_weight
	velocity.y -= net_force * delta  # Afectar la velocidad en el eje Y por la fuerza neta

	# Límite de velocidad
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	
	# Actualizar la posición de la entidad
	#position += velocity * delta
	move_and_slide()
	if health <= 0:
		var dd = damage_scene.instantiate()
		dd.position = position
		get_parent().add_child(dd)
		call_deferred("queue_free")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		# Obtiene el nodo del "bullet" y reduce la salud
		var bullet = area.get_parent()
		health -= bullet.damage
		
		var tween = get_tree().create_tween()
		tween.tween_property($AnimatedSprite2D, "modulate", Color.RED, 1)
		tween.tween_property($AnimatedSprite2D, "modulate", Color.WHITE, 1)
		
		print(bullet.damage)
		
		bullet.queue_free()
