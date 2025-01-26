extends Entity

const SPEED = 200.0  # Velocidad base de movimiento
var bubble: Entity = null  # Referencia a la burbuja
var direction_to_bubble: Vector2  # Dirección hacia la burbuja
var bubble_position: Vector2  # Posición de la burbuja

@onready var animSprite = $AnimatedSprite2D

func _ready() -> void:
	animSprite.play("attack")

	direction_to_bubble = (bubble.position - position).normalized()
	# Calcular la dirección hacia la burbuja cuando el pez se crea
	#if bubble:
		#direction_to_bubble = (bubble.position - position).normalized()  # Dirección hacia la burbuja

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
	
	if health <= 0:
		var dd = damage_scene.instantiate()
		dd.position = position
		get_parent().add_child(dd)
		call_deferred("queue_free")
	
	move_and_slide()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		# Obtiene el nodo del "bullet" y reduce la salud
		var bullet = area.get_parent()
		health -= bullet.damage
		
		bullet.queue_free()
		
		var tween = get_tree().create_tween()
		tween.tween_property($AnimatedSprite2D, "modulate", Color.RED, 1)
		tween.tween_property($AnimatedSprite2D, "modulate", Color.WHITE, 1)
	
		if health <= 0:
			var dd = damage_scene.instantiate()
			dd.position = position
			get_parent().add_child(dd)
			call_deferred("queue_free")
			
	if area.is_in_group("sword"):
		var sword = area.get_parent()
		health -= sword.damage
